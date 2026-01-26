class Admin::DashboardController < Admin::BaseController
  def show
    @users_count = User.count
    @tasks_count = Task.count
    @help_requests_count = HelpRequest.count
    @help_magics_count = HelpMagic.count
  end
end
