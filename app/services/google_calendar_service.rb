require 'google/apis/calendar_v3'
require 'googleauth'

class GoogleCalendarService
  def initialize(user)
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = 'Tukuriba-kazukazu'
    @service.authorization = authorize(user)
  end

  def create_event(summary, start_time, end_time)
    event = Google::Apis::CalendarV3::Event.new({
      summary: summary,
      start: {
        date_time: start_time,
        time_zone: 'Asia/Tokyo',
      },
      end: {
        date_time: end_time,
        time_zone: 'Asia/Tokyo',
      }
    })
    @service.insert_event('primary', event)
  end

  private

  def authorize(user)
    client_id = Google::Auth::ClientId.from_file('path/to/client_secret.json')
    token_store = Google::Auth::Stores::FileTokenStore.new(file: 'path/to/tokens.yaml')
    authorizer = Google::Auth::UserAuthorizer.new(client_id, Google::Apis::CalendarV3::AUTH_CALENDAR, token_store)
    credentials = authorizer.get_credentials(user.id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: 'YOUR_REDIRECT_URI')
      puts "Open the following URL in your browser and authorize the application."
      puts url
      puts "Enter the resulting code:"
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(user.id, code, base_url: 'YOUR_REDIRECT_URI')
    end
    credentials
  end
end
