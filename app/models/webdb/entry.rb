class Webdb::Entry < ApplicationRecord
  include Sys::Model::Base
  include Sys::Model::Base::Config
  include Sys::Model::Auth::Manager
  include Cms::Model::Site
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Editor
  include Sys::Model::Rel::EditableGroup
  include StateText

  belongs_to :db
  validates :db_id, presence: true

  delegate :content, to: :db

  validates :db, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.item_values ||= {} if self.has_attribute?(:item_values)
  end
end
