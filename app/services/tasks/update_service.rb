module Tasks
  class UpdateService
    class ValidationError < StandardError
      attr_reader :task

      def initialize(task)
        @task = task
        super("validation error")
      end
    end

    def initialize(task:, task_params:, help_request_params:)
      @task = task
      @task_params = task_params
      @help_request_params = (help_request_params || {}).to_h.symbolize_keys
    end

    def call!
      @task.assign_attributes(@task_params)

      ActiveRecord::Base.transaction do
        if @task.help_request?
          # help_request が無ければ作る（nested の受け皿）
          @task.build_help_request if @task.help_request.nil?

          # enum はキー文字列（"half_hour" など）をそのまま入れてOK
          @task.help_request.assign_attributes(
            required_time:    @help_request_params[:required_time],
            virtue_points:    @help_request_params[:virtue_points],
            request_message:  @help_request_params[:request_message]
          )

          # 初回作成時の保険（build してるなら status は open でOKだが念のため）
          @task.help_request.status ||= :open
        end

        @task.save!  # Task/HelpRequest の validations がここで効く
      end

      true

    rescue ActiveRecord::RecordInvalid
      # nested の詳細エラーを base にも載せて、画面で出しやすくする（今のUI互換）
      if @task.help_request&.errors&.any?
        @task.help_request.errors.full_messages.each do |msg|
          @task.errors.add(:base, msg)
        end
      end

      raise ValidationError.new(@task)
    end
  end
end
