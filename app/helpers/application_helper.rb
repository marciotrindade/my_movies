module ApplicationHelper

  def javascript(*files)
    content_for(:js) { javascript_include_tag(*files) }
  end

  def title(title)
    content_for(:title) { title.to_s }
  end

  def breadcrumb
    html = link_to_unless_current "Home", root_url
    breadcrumbs.each do |title, link|
      html << " > "
      html << link_to_unless_current(t("breadcrumb.#{title}", :default => title.to_s), eval(link.to_s))
    end
    html.html_safe
  end

  def link_to(name, options = {}, html_options = {})
    html_options.reverse_merge! :title => name
    super(name, options, html_options)
  end

end
