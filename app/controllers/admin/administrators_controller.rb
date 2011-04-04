class Admin::AdministratorsController < Admin::AdminController

  add_breadcrumb :administrators, "collection_path"
  add_breadcrumb :create, '', :only => [:new, :create]
  add_breadcrumb :edit, '', :only => [:edit, :update]
  add_breadcrumb :show, '', :only => [:show]

  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user'

  actions :all, :except => :show

  def create
    @user = User.new(params[:user])
    @user.roles = [Role.find_by_name("Admin")]
    super
  end

  private
  def collection
    @collection ||= Role.find_by_name("Admin").users
  end

end
