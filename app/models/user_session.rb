class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Ooops! Those aren't valid credentials"
end
