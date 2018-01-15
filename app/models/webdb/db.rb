class Webdb::Db < ApplicationRecord
  include Sys::Model::Base
  include Sys::Model::Base::Config
  include Sys::Model::Auth::Manager
  include Cms::Model::Site
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Editor
  include Sys::Model::Rel::EditableGroup
  include StateText

  # Content
  belongs_to :content, :foreign_key => :content_id, :class_name => 'Webdb::Content::Db'
  validates :content_id, :presence => true

  has_many :items, foreign_key: :db_id, class_name: 'Webdb::Item', dependent: :destroy
  has_many :entries, foreign_key: :db_id, class_name: 'Webdb::Entry', dependent: :destroy


  STATE_OPTIONS = [['公開', 'public'], ['非公開', 'closed']]

  default_scope { order("#{self.table_name}.sort_no IS NULL, #{self.table_name}.sort_no") }

  belongs_to :content, :foreign_key => :content_id, :class_name => 'Webdb::Content::Db'
  validates :content_id, presence: true

  validates :title, presence: true

  after_initialize :set_defaults

  scope :public_state, -> { where(state: 'public') }

  def public_items
    items.public_state
  end

  def state_public?
    state == 'public'
  end

  def duplicate
    item = self.class.new(self.attributes.except('id', 'created_at', 'updated_at'))
    item.title = item.title.gsub(/^(【複製】)*/, "【複製】")

    return false unless item.save(validate: false)

    items.each do |i|
      dupe_item = GpTemplate::Item.new(i.attributes.except('id', 'created_at', 'updated_at'))
      dupe_item.template_id = item.id
      dupe_item.save(validate: false)
    end

    return item
  end

  private

  def set_defaults
    self.state   = STATE_OPTIONS.first.last if self.has_attribute?(:state) && self.state.nil?
    self.sort_no = 10 if self.has_attribute?(:sort_no) && self.sort_no.nil?
  end
end
