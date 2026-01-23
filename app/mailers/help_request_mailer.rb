class HelpRequestMailer < ApplicationMailer
  def completed_notify(help_request_id)
    @help_request = HelpRequest.find(help_request_id)
    @task = @help_request.task
    @owner = @task.user
    @helper = @help_request.helper

    mail(
      to: @owner.email,
      subject: "【シャチーク】ヘルプ完了通知：#{@task.title}"
    ) do |format|
      format.text
    end
  end

  def owner_thanks(help_request_id)
    @help_request = HelpRequest.find(help_request_id)
    @task   = @help_request.task
    @owner  = @task.user
    @helper = @help_request.helper

    raise "helper is nil for HelpRequest##{@help_request.id}" if @helper.nil?

    mail(
      to: @helper.email,
      subject: "【シャチーク】完了を確認しました。お手伝いありがとうございました"
    ) do |format|
      format.text
    end
  end
end
