class PublicController < ActionController::Base
  skip_before_filter :authorize_action
end
