class Webdb::Public::Node::DbsController < Cms::Controller::Public::Base
  #protect_from_forgery :except => [:login]

  def pre_dispatch
    @content = ::Webdb::Content::Db.find_by(id: Page.current_node.content.id)
    return http_error(404) unless @content
    @node = Page.current_node
  end

  def index
    @dbs = @content.public_dbs
  end

  def show
    @db    = @content.public_dbs.find_by(id: params[:id])
    return http_error(404) unless @db
    Page.title = @db.title
    @items = @db.public_items.target_search_state
  end

  def map
    result
    @markers = @items.joins(maps: :markers).distinct
    markers = []
    @markers.each do |entry|
      markers << entry.map_marker
    end
    @all_markers = markers.flatten
  end

  def address
    @db    = @content.public_dbs.find_by(id: params[:db_id])
    return http_error(404) unless @db
    Page.title = @db.title
  end

  def result
    @db    = @content.public_dbs.find_by(id: params[:db_id])
    return http_error(404) unless @db
    @entries = @db.entries.public_state
    criteria = entry_criteria
    @items = Webdb::EntriesFinder.new(@db, @entries, Core.user).search(criteria).distinct
  end

  def entry
    @db    = @content.public_dbs.find_by(id: params[:db_id])
    return http_error(404) unless @db
    @entry = @db.entries.find_by(name: params[:name])
  end

  private

  def entry_criteria
    params[:criteria] ? params[:criteria].to_unsafe_h : {}
  end

end