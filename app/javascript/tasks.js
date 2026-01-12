document.addEventListener("turbo:load", () => {
  const addTaskBtn = document.getElementById("add-task-btn");
  const tasksContainer = document.getElementById("tasks-container");

  if (addTaskBtn && tasksContainer) {
    // タスク追加ボタンのクリックイベント
    addTaskBtn.addEventListener("click", () => {
      const taskCount = tasksContainer.querySelectorAll(".task-field").length;

      // 最大10個まで制限
      if (taskCount >= 10) {
        alert("タスクは最大10個までです");
        return;
      }

      // 新しいタスクフィールドを作成
      const newTaskField = document.createElement("div");
      newTaskField.className =
        "task-field border border-gray-300 rounded-lg p-4 bg-white";
      newTaskField.innerHTML = `
        <div class="space-y-3">
          <div class="flex flex-col">
            <label class="text-sm font-medium text-gray-700 mb-1">タイトル</label>
            <input class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                   type="text"
                   name="tasks[][title]"
                   placeholder="例: 資料作成"
                   required>
          </div>

          <div class="flex flex-col">
            <label class="text-sm font-medium text-gray-700 mb-1">ステータス</label>
            <select class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                    name="tasks[][status]"
                    required>
              <option value="todo">未着手</option>
              <option value="doing">着手中</option>
              <option value="done">完了</option>
            </select>
          </div>

          <div class="flex flex-col">
            <label class="text-sm font-medium text-gray-700 mb-1">必要時間</label>
            <select class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                    name="tasks[][required_time]"
                    required>
              <option value="half_hour">30分</option>
              <option value="one_hour">1時間</option>
              <option value="two_hours">2時間</option>
              <option value="three_hours">3時間</option>
              <option value="half_day">半日</option>
              <option value="one_day">1日</option>
            </select>
          </div>

          <div class="flex flex-col">
            <label class="text-sm font-medium text-gray-700 mb-1">内容（任意）</label>
            <textarea class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                      name="tasks[][description]"
                      rows="3"
                      placeholder="タスクの詳細を入力（任意）"></textarea>
          </div>

          <div class="text-right">
            <button class="bg-red-500 text-white px-3 py-2 rounded-lg hover:bg-red-600 transition remove-task-btn"
                    type="button">❌ 削除</button>
          </div>
        </div>
      `;

      tasksContainer.appendChild(newTaskField);

      // 新しく追加したフィールドにフォーカス
      newTaskField.querySelector("input").focus();

      // 削除ボタンのイベントを設定
      attachRemoveEvent(newTaskField.querySelector(".remove-task-btn"));
    });

    // 削除ボタンのイベント設定関数
    function attachRemoveEvent(btn) {
      btn.addEventListener("click", (e) => {
        const taskFields = tasksContainer.querySelectorAll(".task-field");
        // 最低1つは残す
        if (taskFields.length > 1) {
          e.target.closest(".task-field").remove();
        } else {
          alert("タスクは最低1つ必要です");
        }
      });
    }

    // 初期の削除ボタンにもイベントを設定
    const initialRemoveBtn = tasksContainer.querySelector(".remove-task-btn");
    if (initialRemoveBtn) {
      attachRemoveEvent(initialRemoveBtn);
    }
  }
});
