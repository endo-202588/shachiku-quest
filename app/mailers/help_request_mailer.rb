class HelpRequestMailer < ApplicationMailer
  def completed_notify(help_request_id)
    @help_request = HelpRequest.find(help_request_id)
    @task = @help_request.task
    @owner = @task.user
    @helper = @help_request.helper

    mail(to: @owner.email,
         subject: "【シャチーク】ヘルプ完了通知：#{@task.title}") do |format|
      format.text
    end
  end
end
