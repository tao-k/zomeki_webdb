class Webdb::EntryCsv < Webdb::Csv
  default_scope { where(:csv_type => self.name) }

  def parse_line(row, i)

    line = csv_lines.build(:line_no => i+2, :data => row.fields, :data_type => 'Webdb::Entry')

    entry = db.entries.where(id: row['ID']).first || db.entries.new
    entry_attributes = {}
    date_attributes = {}
    entry_attributes['db_id'] = db.id
    entry_attributes['id']    = row['ID']
    entry_attributes['title'] = row['タイトル']
    json_attributes = {}
    in_target_dates = {}

    db.items.each do |item|
      case item.item_type
      when 'office_hours'
        #
      when 'blank_weekday'
        #
      when 'blank_date'
        row[item.title].split(/／/).each do |d|
          date_val = d.split(/：/)
          in_target_dates << {
            option_value: date_val[1],
            name: item.name,
            event_date: date_val[0]
          }
        end
      when 'ampm'
        #
      else
        json_attributes[item.name] = row[item.title]
      end
    end

    entry_attributes[:item_values] = json_attributes
    entry_attributes[:in_target_dates] = in_target_dates

    entry_attributes.each do |key , value|
      next if key == :rid
      entry[key] = value
    end
    entry.validate
    line.data_attributes = {
      entry_attributes: entry_attributes,
      date_attributes: date_attributes
    }
    line.data_invalid = entry.errors.blank? ? 0 : 1
    line.data_errors = entry.errors.full_messages.to_a if entry.errors.present?
    line
  end

  def register(line)
    entry_attributes = line.csv_data_attributes['entry_attributes']
    date_attributes  = line.csv_data_attributes['date_attributes']
    entry = db.entries.where(id: entry_attributes['id']).first || db.entries.new

    entry_attributes.each do |key , value|
      next if key == :id
      entry[key] = value
    end
    entry.in_target_dates = date_attributes if date_attributes.present?

    entry.save
    entry
  end
end
