class StatusHistoriesController < ApplicationController
  def index
    @status = Status.find(params[:status_id])
    @status_histories = @status.status_histories.order(created_at: :desc)
  end
end
