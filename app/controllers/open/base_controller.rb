class Open::BaseController < ActionController::Base
  allow_browser versions: :modern
  layout "application"
end
