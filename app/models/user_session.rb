class UserSession < Authlogic::Session::Base
  extend ActiveModel::Naming # hack to allow this class to be mocked by RSpec
end