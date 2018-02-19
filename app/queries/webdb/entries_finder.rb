class Webdb::EntriesFinder < ApplicationFinder
  def initialize(db, entries, user)
    @db = db
    @entries = entries
    @user = user
  end

  def search(criteria)
    @db.items.target_search_state.each do |item|
      next unless value = criteria[item.name.to_sym]
      case item.item_type
      when 'ampm'
        #
      else
        Rails.logger.debug item.name
        @entries = @entries.where("item_values->>'#{item.name}' = ?", value)
      end
    end
    if criteria[:sort]
      columns = @db.items.target_sort_state.pluck(:name)
      key, order  = criteria[:sort].split(/\s/)
      if idx = columns.index(key).present?
        @entries = @entries.order("item_values ->'#{columns[idx]}' #{ordering(order)}")
      end
    end
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
