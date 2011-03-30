require File.dirname(__FILE__) + '/../spec_helper'

describe Right do

  before do
    @right = Right.create(:action => "any_one", :name => "Any One")
  end

  should_validate_uniqueness_of :action
  should_have_and_belong_to_many :roles

  it "should populate rights with routes of the system" do
    routes_mock = mock('routes')
    first_mock_route = mock('first_route')
    first_mock_route.stubs(:defaults).returns({:controller => "admin/test_route", :action => "test_action"})

    routes_mock.stubs(:select).returns([first_mock_route])
    Rails.application.routes.stubs(:routes).returns(routes_mock)

    Right.count.should == 1
    Right.all.should == [@right]

    Right.populate_from_routes

    Right.count.should == 2
    Right.first.should == @right
    Right.last.action.should == "admin/test_route/test_action/"
    Right.last.name.should == "Test Route => Test Action"
  end

end
