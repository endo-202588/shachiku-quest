import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { data: Object };

  connect() {
    requestAnimationFrame(() => this.renderChart());
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }

  renderChart() {
    // DB enum: 0=快調,1=疲れ気味,2=忙しい,3=とても忙しい,4=過負荷,5=休み
    const statusMap = {
      0: "快調",
      1: "疲れ気味",
      2: "忙しい",
      3: "とても忙しい",
      4: "過負荷",
      5: "休み",
    };

    // y軸ラベル（元気度：下→上）
    // y=0:過負荷,1:とても忙しい,2:忙しい,3:疲れ気味,4:快調,5:休み
    const yLabels = [
      "過負荷",
      "とても忙しい",
      "忙しい",
      "疲れ気味",
      "快調",
      "休み",
    ];
    const MAX = 5;

    const data = this.dataValue;

    const canvas = this.element.querySelector("canvas");
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    if (this.chart) this.chart.destroy();

    // DB値 v(0..5) → 元気度y(0..5)
    const toVitality = (v) => (v === 5 ? 5 : 4 - v);
    const fromVitality = (y) => (y === 5 ? 5 : 4 - y);

    // =========================
    // 期間ラベル（直近30日）を作る
    // =========================
    const DAYS = 30;

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const labels = [];
    for (let i = DAYS - 1; i >= 0; i--) {
      const d = new Date(today);
      d.setDate(d.getDate() - i);
      labels.push(this.toYmd(d)); // "YYYY-MM-DD"
    }

    // =========================
    // status_history を Map 化（"YYYY-MM-DD" => value）
    // =========================
    const historyMap = new Map();
    (data.status_history || []).forEach((item) => {
      const dateStr = String(item.date ?? "");
      const v = Number(item.value);
      if (!dateStr) return;
      if (!Number.isFinite(v)) return;

      // Rails が "YYYY-MM-DD" を返している前提（違ってもここで正規化）
      const normalized = this.normalizeToYmd(dateStr);
      if (!normalized) return;

      historyMap.set(normalized, v);
    });

    // labels に合わせて values を作る（無い日は null）
    const values = labels.map((ymd) => {
      if (!historyMap.has(ymd)) return null;
      return toVitality(historyMap.get(ymd));
    });

    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets: [
          {
            label: data.name,
            data: values,
            borderColor: "rgb(75, 192, 192)",
            backgroundColor: "rgba(75, 192, 192, 0.2)",
            tension: 0.3,
            spanGaps: true,
            pointRadius: 3,
            pointHoverRadius: 5,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,

        plugins: {
          legend: { labels: { boxWidth: 32 } },
          tooltip: {
            callbacks: {
              title: (items) => {
                // x軸ラベル（YYYY-MM-DD）→表示用（MM/DD）
                const s = items?.[0]?.label || "";
                if (/^\d{4}-\d{2}-\d{2}$/.test(s))
                  return `${s.slice(5, 7)}/${s.slice(8, 10)}`;
                return s;
              },
              label: (context) => {
                const y = Math.round(context.parsed.y);
                const original = fromVitality(y);
                return `${data.name}: ${statusMap[original] ?? original}`;
              },
            },
          },
        },

        scales: {
          x: {
            type: "category",
            ticks: {
              autoSkip: true, // ★ 全日付を表示
              maxRotation: 0,
              minRotation: 0,
              callback: (value, index) => {
                const s = labels[index];
                // "YYYY-MM-DD" → "MM/DD"
                return `${s.slice(5, 7)}/${s.slice(8, 10)}`;
              },
            },
          },
          y: {
            min: 0,
            max: MAX + 1, // 上に余白
            ticks: {
              stepSize: 1,
              autoSkip: false,
              callback: (v) => (v === MAX + 1 ? "" : (yLabels[v] ?? v)),
            },
          },
        },
      },
    });
  }

  // Date -> "YYYY-MM-DD"
  toYmd(d) {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${y}-${m}-${day}`;
  }

  // "YYYY-MM-DD" or "YYYY-MM-DDTHH:mm..." -> "YYYY-MM-DD"
  normalizeToYmd(s) {
    if (!s) return null;
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;

    // ISOっぽいなら Date で正規化
    const d = new Date(s);
    if (Number.isNaN(d.getTime())) return null;
    d.setHours(0, 0, 0, 0);
    return this.toYmd(d);
  }
}
