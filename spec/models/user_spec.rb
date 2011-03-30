require File.dirname(__FILE__) + '/../spec_helper'
require 'digest/md5'

describe User do

  should_have_db_index :username
  should_have_db_index :email
  should_have_db_index :reset_password_token

  should_validate_presence_of :name, :email, :username

  should_have_and_belong_to_many :roles

  it "should create with valid attributes" do
    user = Factory.build(:user)
    user.should be_valid
  end

  it "should return rights" do
    user = Factory(:user)
    user.rights.should == []
    Right.all.should == []

    right = Right.create(:name => "Testing Right", :action => "users/index/")
    role = Factory(:role)

    role.rights << right
    user.roles << role

    User.find(user.id).rights.should == [right]
  end

  it "should not update the password when is blank" do
    user = Factory(:user, :password => "test", :password_confirmation => "test")
    user.update_attributes({:name => "Marcio", :password => "", :password_confirmation => ""})
    User.find(user.id).valid_password?('test').should == true
  end

  describe "with permissions" do
    before do
      @user = Factory(:user)
      @user.rights.should == []

      @right = Right.create(:name => "Testing Right", :action => "users/index/")
      @role = Role.create(:name => "admin")

      @role.rights << @right
      @user.roles << @role

      @user = User.find(@user.id)
    end

    it "should allow access to the given action when the user has the rights" do
      @user.has_access_to?(@right.action).should == true
    end

    it "should deny access to the given action when user does not have the rights" do
      @user.has_access_to?("a different action").should == false
    end
  end

end
