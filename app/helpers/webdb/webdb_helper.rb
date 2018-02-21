module Webdb::WebdbHelper
  def entry_body(type, db, item_values, files)
    template_body = case type
    when :list
      db.list_body
    when :detail
      db.list_body
    when :member_list
      db.member_listbody
    when :member_detail
      db.member_detail_body
    else
      nil
    end
    return nil if template_body.blank?
    db.items.inject(template_body.to_s) do |body, item|
      body.gsub(/\[\[item\/#{item.name}\]\]/i, entry_item_value(item, item_values[item.name].to_s, files))
    end
  end

  def entry_item_value(item, entry, files)
    Rails.logger.debug item.item_type
    value = entry.item_values[item.name]
    case item.item_type
    when 'text_area'
      value = br(value) if value.present?
    when 'attachment_file'
      if file = files.detect {|f| f.name == value }
        if file.image_is == 1
          value = content_tag('image', '', src: "file_contents/#{file.name}", title: file.title)
        else
          value = content_tag('a', file.united_name, href: "file_contents/#{file.name}", class: file.css_class)
        end
      end
    when 'select_data', 'radio_data'
      if select_data = item.item_options_for_select_data
        select_data.each{|e| value = e[0] if e[1]== entry.item_values[item.name].to_i }
      end
    when 'ampm', 'office_hours', 'blank_weekday', 'check_box', 'check_data'
      if entry.item_values[item.name]
        value =  entry.item_values[item.name]['text']
      end
    end
    value
  end
end
