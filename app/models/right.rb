class Right < ActiveRecord::Base

  validates_uniqueness_of :action
  has_and_belongs_to_many :roles

  default_scope :order => "rights.name"

  def self.populate_from_routes
    existing_routes = []
    Rails.application.routes.routes.select{|route| route.defaults[:controller] =~ (/admin|callcenter/)}.each do |route|
      action_name = "#{route.defaults[:controller].gsub(/admin\//, "")} => #{route.defaults[:action]}".humanize.titleize
      action = "#{route.defaults[:controller]}/#{route.defaults[:action]}/"
      # aciciona as rotas que não serão destruidas
      existing_routes << action

      right = Right.find_or_create_by_action(action)
      right.update_attribute(:name, action_name)
    end
  end

end
