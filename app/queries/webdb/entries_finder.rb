class Webdb::EntriesFinder < ApplicationFinder
  def initialize(db, entries, user)
    @db = db
    @entries = entries
    @user = user
  end

  def search(criteria)
    @db.items.target_search_state.each do |item|
      value = criteria[item.name.to_sym]
      next if value.blank?
      case item.item_type
      when 'check_box', 'check_data'
        @entries = @entries.where("item_values -> '#{item.name}' -> 'check' ?& array[:keys]", keys: value.values)
      when 'ampm'
        am_idx = value['am'].present? ? value['am'].keys : []
        pm_idx = value['pm'].present? ? value['pm'].keys : []
        if am_idx.present? && pm_idx.present?
          @entries = @entries.where(
            "(item_values -> '#{item.name}' -> 'am' ?| array[:am_keys]) OR" +
            "(item_values -> '#{item.name}' -> 'pm' ?| array[:pm_keys])", am_keys:am_idx, pm_keys: pm_idx
            )
        elsif am_idx.present?
          @entries = @entries.where("item_values -> '#{item.name}' -> 'am' ?| array[:keys]", keys: am_idx)
        elsif pm_idx.present?
          @entries = @entries.where("item_values -> '#{item.name}' -> 'pm' ?| array[:keys]", keys: pm_idx)
        end
      else
        @entries = @entries.where("item_values ->> '#{item.name}' = ?", value)
      end
    end
    #sort_columns = @db.items.target_sort_state.pluck(:name)
    #if sort_key && sort_columns
    #  key, order  = sort_key.split(/\s/)
    #  Rails.logger.debug sort_columns
    #  if idx = sort_columns.index(key)
    #    Rails.logger.debug sort_columns[idx]
    #    @entries = @entries.order("item_values ->> '#{sort_columns[idx]}' #{ordering(order)}")
    #  end
    #end
    @entries
  end

  private

  def arel_table
    @entries.arel_table
  end

  def ordering(order)
    order == "asc" ? "ASC" : "DESC"
  end

end
