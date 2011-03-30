module ControllerMacros

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def actions_filtred (options={})
      default_actions = {
        :index => [:html, :xml],
        :show =>  [:html, :xml],
        :new =>  [:html, :xml],
        :create =>  [:success, :fail],
        :edit =>  [:html, :xml],
        :update =>  [:success, :fail],
        :destroy =>  [:success, :fail]
      }

      [options[:except]].flatten.each do |action|
        default_actions.delete(action)
      end if options[:except].present?

      default_actions.each do |action, formats|
        default_actions.delete(action) unless [options[:only]].flatten.include?(action)
      end if options[:only].present?

      default_actions = options[:exactly] if options[:exactly].present?

      default_actions
    end

    def should_respond_to_resources(options={})
      actions = actions_filtred(options)

      # routes
      should_respond_to_resources_routes(actions)

      # actions
      actions.each do |action, options|
        options.each do |option|
          send("should_respond_to_#{action}", option)
        end
      end
    end

    def should_respond_to_resources_routes(actions)
      it "should respond to resources routes" do
        { :get    => "#{string_for_route}"}.should          route_to(hash_for_route.merge(:action => "index")) if should_show(actions, :index)
        { :get    => "#{string_for_route}/new"}.should      route_to(hash_for_route.merge(:action => "new")) if should_show(actions, :new)
        { :get    => "#{string_for_route}/1"}.should        route_to(hash_for_route.merge(:action => "show", :id => "1")) if should_show(actions, :show)
        { :get    => "#{string_for_route}/1/edit"}.should   route_to(hash_for_route.merge(:action => "edit", :id => "1")) if should_show(actions, :edit)
        { :post   => "#{string_for_route}"}.should          route_to(hash_for_route.merge(:action => "create")) if should_show(actions, :create)
        { :put    => "#{string_for_route}/1"}.should        route_to(hash_for_route.merge(:action => "update", :id => "1")) if should_show(actions, :update)
        { :delete => "#{string_for_route}/1"}.should        route_to(hash_for_route.merge(:action => "destroy", :id => "1")) if should_show(actions, :destroy)
      end
    end

    def should_respond_to_index(format=nil)
      it "should respond to index with #{format} format" do
        get :index, {:format => format}.merge(parent_params)

        assigns[:collection].should_not nil
        response.should be_success
        response.should render_template(:index) if format.nil?
        mime_should_eq(format)
      end
    end

    def should_respond_to_show(format=nil)
      it "should respond to show with #{format} format" do
        get :show, {:id => @object, :format => format}.merge(parent_params)

        assigns(model.to_sym).should_not be_blank
        response.should be_success
        response.should render_template(:show) if format.nil?
        mime_should_eq(format)
      end
    end

    def should_respond_to_new(format)
      it "should respond to new with #{format} format" do
        get :new, {:format => format}.merge(parent_params)

        assigns(model.to_sym).should_not be_blank
        response.should be_success
        should render_template(:new) if format == :html
        mime_should_eq(format)
      end
    end

    def should_respond_to_create(status)
      it "should respond #{status} to create" do
        status = (status == :success)
        model_class.any_instance.stubs(:save).returns(status)
        model_class.any_instance.stubs(:errors).returns(status ? "" : model_errors)

        post :create, parent_params

        if status
          flash[:notice].should == I18n.t("flash.create.success")
          response.should redirect_to(collection_path)
        else
          should render_template(:new)
        end
      end
    end

    def should_respond_to_edit(format=nil)
      it "should respond to edit with #{format} format" do
        get :edit, {:id => @object.id, :format => format}.merge(parent_params)

        assigns(model.to_sym).should_not be_blank
        response.should be_success
        should render_template(:edit) if format.nil?
        mime_should_eq(format)
      end
    end

    def should_respond_to_update(status)
      it "should respond #{status} to update" do
        status = (status == :success)
        model_class.any_instance.stubs(:update_attributes).returns(status)
        model_class.any_instance.stubs(:errors).returns(status ? "" : model_errors)

        put :update, {:id => @object.id, model.to_sym => {}}.merge(parent_params)

        if status
          flash[:notice].should == I18n.t("flash.update.success")
          response.should redirect_to(collection_path)
        else
          should render_template(:edit)
        end
      end
    end

    def should_respond_to_destroy(status)
      it "should respond #{status} to destroy" do
        status = (status == :success)
        model_class.any_instance.stubs(:destroy).returns(status)
        model_class.any_instance.stubs(:errors).returns(status ? "" : model_errors)

        delete :destroy, {:id =>  @object.id}.merge(parent_params)

        flash[:notice].should == I18n.t("flash.destroy.success") if status
        flash[:alert].should == I18n.t("flash.destroy.alert") unless status
        response.should redirect_to(collection_path)
      end
    end

  end

  def do_index(format)
    get :index, {:format => format}.merge(parent_params)
  end

  def do_show(format)
    get :show, {:id => @object, :format => format}.merge(parent_params)
  end

  def clear(format)
    nil if format.eql?(:html)
  end

  def model_class
    @object.class
  end

  def model_errors
    errors = ActiveModel::Errors.new(model_class.new)
    errors.add_on_blank(:id)
    errors
  end

  def model
    model_class.to_s.underscore
  end

  def should_show(actions, action)
    actions.include?(action)
  end

  def route_prefix
    @route_prefix ||= described_class.resources_configuration[:self][:route_prefix]
  end

  def string_for_route
    if parent_name.present?
      "/#{route_prefix}/#{parent_name.pluralize}/1/#{model.pluralize}"
    else
      "/#{route_prefix}/#{model.pluralize}"
    end
  end

  def hash_for_route
    if parent_name.present?
      {:controller => "#{route_prefix}/#{model.pluralize}", parent_key => "1"}
    else
      {:controller => "#{route_prefix}/#{model.pluralize}"}
    end
  end

  def parent_name
    @parent_name ||= described_class.parents_symbols[0].to_s
  end

  def parent_controller
    @parent_controller ||= "#{route_prefix}/#{parent_name}".classify
  end

  def parent_key
    described_class.resources_configuration[parent_name.to_sym][:param]
  end

  def parent_params
    if parent_name.present?
      {parent_key => @object.parent}
    else
      {}
    end
  end

  def collection_path
    if parent_name.present?
      path = "#{route_prefix.to_s}_#{@object.parent.class.to_s.underscore}_#{@controller.controller_name}_path"
    else
      path = "#{route_prefix.to_s}_#{@controller.controller_name}_path"
    end
    send(path)
  end

  def mime_should_eq(sym)
    Mime::Type.parse(response.content_type)[0].to_sym.should == sym
  end

end
