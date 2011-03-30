require 'spec_helper'

describe Admin::RolesController do

  render_views

  before do
    Admin::RolesController.any_instance.stubs(:check_credentials)
    @object = Factory(:role)
  end

  should_respond_to_resources :except => [ :show ]

end
