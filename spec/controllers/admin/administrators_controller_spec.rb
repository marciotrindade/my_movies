require 'spec_helper'

describe Admin::AdministratorsController do

  render_views

  before do
    Admin::AdministratorsController.any_instance.stubs(:check_credentials)
    Factory(:role, :name => "Admin")
    @object = Factory(:user)
  end

  should_respond_to_resources :except => [ :show ]

end
