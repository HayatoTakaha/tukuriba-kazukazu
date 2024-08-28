class ReservationsController < ApplicationController
  def create
    start_time = params[:start_time]
    end_time = params[:end_time]
    summary = params[:summary]

    google_calendar_service = GoogleCalendarService.new(current_user)
    google_calendar_service.create_event(summary, start_time, end_time)

    redirect_to reservations_path, notice: "予約が完了しました。"
  end
end
