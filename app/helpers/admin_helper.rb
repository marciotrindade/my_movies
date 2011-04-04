# coding: utf-8
module AdminHelper

  def reorder_elements
    content_for(:js) do
      sortable_element 'order',
            :complete => visual_effect(:highlight, 'order'),
            :url => { :action => "order" }
    end
  end

  def data_table(options={})
    options.reverse_merge! "sPaginationType" => "full_numbers",
                          "bStateSave" => true,
                          "bInfo" => false,
                          "iDisplayLength" => "100",
                          "aaSorting" => [[ 0, "asc"]]
    content_for(:js) do
      javascript_tag do
        "$('.table').dataTable(#{options.to_json});".html_safe
      end
    end
  end

  def admin_title
    text = ""
    text << AppConfig.site.name
    breadcrumbs.each do |title, link|
      text << " - "
      text << t(title, :scope => :breadcrumbs, :default => title.to_s)
    end
    text
  end

end