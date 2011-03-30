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
                          "aaSorting" => [[ 0, "asc"]],
                          "oLanguage" => { "sUrl" => "/javascripts/plugins/data_tables_#{I18n.locale}.js" }
    content_for(:js) do
      javascript_tag do
        "$('.table').dataTable(#{options.to_json}).css('width', 'auto');".html_safe
      end
    end
  end

end