require File.dirname(__FILE__) + '/../spec_helper'

describe Role do

  should_validate_presence_of :name
  should_have_and_belong_to_many :rights, :users
  
  it "default scope order by name" do
    role_one = Factory(:role, :name => "Zilda")
    role_two = Factory(:role, :name => "Andre")
    
    Role.first.should == role_two
    Role.last.should == role_one
  end

end
