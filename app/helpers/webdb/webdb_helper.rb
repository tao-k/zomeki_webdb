module Webdb::WebdbHelper
  def entry_body(db, item_values, files)
    db.items.inject(template.body.to_s) do |body, item|
      body.gsub(/\[\[item\/#{item.name}\]\]/i, entry_item_value(item, item_values[item.name].to_s, files))
    end
  end

  def entry_item_csv_value(item, entry, files)
    value = entry.item_values[item.name]
    case item.item_type
    when 'attachment_file'
      if file = files.detect {|f| f.name == value }
        value = "file_contents/#{file.name}"
      end
    when 'ampm'
      if entry.item_values[item.name] && entry.item_values[item.name]['am'] && entry.item_values[item.name]['pm']
        am_values = []
        pm_values = []
        if entry.item_values[item.name]['am']
          entry.item_values[item.name]['am'].each{|key, val|
            am_values << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{val}"
          }
        end
        if entry.item_values[item.name]['pm']
          entry.item_values[item.name]['pm'].each{|key, val|
            pm_values << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{val}"
          }
        end
        value = "午前　#{am_values.join('／')}"
        value += "　午後　#{pm_values.join('／')}"
     end
    when 'office_hours'
      if entry.item_values[item.name] && entry.item_values[item.name]['open']
        office_hours = []
        entry.item_values[item.name]['open'].each{|key, val|
          open_at  = val
          close_at = entry.item_values[item.name]['close'].present? ? entry.item_values[item.name]['close'][key] : nil
          office_hours << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{open_at}　～　#{close_at}"
        }
        value = "　#{office_hours.join('／')}"
        value += "　#{entry.item_values[item.name]['remark']}"
      end
    when 'blank_weekday'
      if entry.item_values[item.name] && entry.item_values[item.name]['weekday']
        days = []
        entry.item_values[item.name]['weekday'].each{|key, val|
          days << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{val}"
        }
        value = days.join('／')
      end
    when 'blank_date'
      blank_dates = []
      entry.dates.where(name: item.name).each{|e| blank_dates << %Q(#{e.event_date.strftime("%Y-%m-%d")}：#{e.option_value}) }
      value = blank_dates.join('／')
    end
    value
  end

  def entry_item_value(item, entry, files)
    value = entry.item_values[item.name]
    case item.item_type
    when 'text_area'
      value = br(value)
    when 'attachment_file'
      if file = files.detect {|f| f.name == value }
        if file.image_is == 1
          value = content_tag('image', '', src: "file_contents/#{file.name}", title: file.title)
        else
          value = content_tag('a', file.united_name, href: "file_contents/#{file.name}", class: file.css_class)
        end
      end
    when 'ampm'
      if entry.item_values[item.name]
        am_values = []
        pm_values = []
        if entry.item_values[item.name]['am']
          entry.item_values[item.name]['am'].each{|key, val|
            am_values << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{val}"
          }
        end
        if entry.item_values[item.name]['pm']
          entry.item_values[item.name]['pm'].each{|key, val|
            pm_values << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{val}"
          }
        end
        value = content_tag('div', "午前　#{am_values.join('／')}")
        value += content_tag('div', "午後　#{pm_values.join('／')}")
     end
    when 'office_hours'
      office_hours = []
      if entry.item_values[item.name]
        entry.item_values[item.name]['open'].each{|key, val|
          open_at  = val
          close_at = entry.item_values[item.name]['close'].present? ? entry.item_values[item.name]['close'][key] : nil
          office_hours << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{open_at}　～　#{close_at}"
        }
        value = content_tag('div', office_hours.join('／'))
        value += content_tag('div', entry.item_values[item.name]['remark'])
      end
    when 'blank_weekday'
      if entry.item_values[item.name]
        days = []
        entry.item_values[item.name]['weekday'].each{|key, val|
          days << "#{entry.class::WEEKDAY_OPTIONS[key.to_i]}：#{val}"
        }
        value = content_tag('div', days.join('／'))
      end
    when 'blank_date'
      blank_dates = []
      entry.dates.where(name: item.name).each{|e| blank_dates << %Q(#{e.event_date.try(:strftime, '%Y-%m-%d')}：#{e.option_value}) }
      value = content_tag('div', blank_dates.join('／'))
    end
    value
  end
end
