require 'spec_helper'

describe Admin::UsersController do

  render_views

  before do
    Admin::UsersController.any_instance.stubs(:check_credentials)
    @object = Factory(:user)
  end

  should_respond_to_resources :except => [ :show ]

  it "should respond to profile" do
    Admin::UsersController.any_instance.stubs(:current_user).returns(@object)
    get :profile

    assigns(:user).should == @object
    response.should be_success
    should render_template(:profile)
  end

  it "should respond success to update profile" do
    Admin::UsersController.any_instance.stubs(:current_user).returns(@object)
    User.any_instance.stubs(:update_attributes).returns(true)

    put :update_profile, {:id => @object.id}

    flash[:notice].should == I18n.t("flash.update.success")
    response.should redirect_to(profile_admin_users_path)
  end

  it "should respond fail to update profile" do
    Admin::UsersController.any_instance.stubs(:current_user).returns(@object)
    User.any_instance.stubs(:update_attributes).returns(false)

    put :update_profile, {:id => @object.id}

    flash[:error].should == I18n.t("flash.update.alert")
    should render_template(:profile)
  end

end
