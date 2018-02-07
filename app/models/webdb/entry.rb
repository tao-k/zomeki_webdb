class Webdb::Entry < ApplicationRecord
  include Sys::Model::Base
  include Sys::Model::Base::Config
  include Sys::Model::Auth::Manager
  include Cms::Model::Site
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Editor
  include Sys::Model::Rel::File
  include ZomekiWebdb::Model::Rel::TargetDate
  include StateText

  WEEKDAY_OPTIONS = ['日', '月', '火', '水', '木', '金', '土','祝']

  belongs_to :db
  validates :db_id, presence: true

  delegate :content, to: :db

  validates :db, presence: true
  validates :title, presence: true

  after_initialize :set_defaults
  before_save :set_name

  def file_content_uri
    if content.public_node.present?
      %Q("#{content.public_node.public_uri}#{name}/file_contents/)
    else
      %Q(#{content.admin_uri}/#{id}/file_contents/)
    end
  end

  def editor_user
    return nil unless defined?(ZomekiLogin::Engine)
    return nil if editor_id.blank?
    Login::User.find_by(id: editor_id)
  end

  private

  def set_name
    return if self.name.present?
    date = if created_at
             created_at.strftime('%Y%m%d')
           else
             Date.strptime(Core.now, '%Y-%m-%d').strftime('%Y%m%d')
           end
    seq = Util::Sequencer.next_id('gp_article_docs', version: date, site_id: content.site_id)
    self.name = Util::String::CheckDigit.check(date + format('%04d', seq))
  end

  def set_defaults
    self.item_values ||= {} if self.has_attribute?(:item_values)
  end
end
