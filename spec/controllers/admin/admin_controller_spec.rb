require 'spec_helper'

describe Admin::UsersController do

  include Devise::TestHelpers

  render_views

  it "should permit to access the admin when have credentials" do
    Admin::UsersController.any_instance.stubs(:check_credentials).returns(true)

    get :index

    response.should be_success
    mime_should_eq(:html)
  end

  it "should not permit to access the admin when not logged in" do
    get :index

    flash[:alert].should == I18n.t("devise.failure.unauthenticated")
    response.should redirect_to(new_user_session_path)
  end

  it "should not permit to access the admin when logged but don't have credentials" do
    @user = Factory(:user)
    Admin::UsersController.any_instance.stubs(:authenticate_user!).returns(true)
    Admin::UsersController.any_instance.stubs(:current_user).returns(@user)

    get :index

    flash[:alert].should == I18n.t("devise.failure.access_denied")
    response.should redirect_to(root_path)
  end

end
