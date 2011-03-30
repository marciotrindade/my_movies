class Admin::UsersController < Admin::AdminController

  add_breadcrumb :user, "collection_path"
  add_breadcrumb :create, '', :only => [:new, :create]
  add_breadcrumb :edit, '', :only => [:edit, :update]
  add_breadcrumb :show, '', :only => [:show]

  actions :all, :except => :show

  def profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    respond_to do |wants|
      if @user.update_attributes(params[:user])
        flash[:notice] = I18n.t("flash.update.success")
        wants.html { redirect_to(profile_admin_users_path) }
        wants.xml  { head :ok }
      else
        flash[:error] = I18n.t("flash.update.alert")
        wants.html { render :action => "profile" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
