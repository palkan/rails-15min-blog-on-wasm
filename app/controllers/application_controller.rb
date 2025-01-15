class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Disable CSRF protection to make the app work in iframe from anywhere.
  skip_before_action :verify_authenticity_token
end
