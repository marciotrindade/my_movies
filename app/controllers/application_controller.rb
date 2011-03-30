class ApplicationController < ActionController::Base

  protect_from_forgery

  helper_method :breadcrumbs

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end

  def add_breadcrumb(name, link)
    breadcrumbs << [name, link]
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

end
