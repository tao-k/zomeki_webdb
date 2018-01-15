class Webdb::Admin::EntriesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base

  def pre_dispatch
    @content = Webdb::Content::Db.find(params[:content])
    return error_auth unless Core.user.has_priv?(:read, item: @content.concept)
    @db = @content.dbs.find(params[:db_id])
  end

  def index
    @items = @db.entries.paginate(page: params[:page], per_page: 30)
    _index @items
  end

  def show
    @item = @db.entries.find(params[:id])
    _show @item
  end

  def new
    @item = @db.entries.build
  end

  def create
    @item = @db.entries.build(item_params)
    _create @item
  end

  def update
    @item = @db.entries.find(params[:id])
    @item.attributes = item_params
    _update @item
  end

  def destroy
    @item = @db.entries.find(params[:id])
    _destroy @item
  end

  private

  def item_params
    params.require(:item).permit(:item_options, :item_type, :name, :sort_no,
      :state, :style_attribute, :title, :target_sort, :target_search,
      :target_keyword, :limited_access,
      :creator_attributes => [:id, :group_id, :user_id])
  end
end
