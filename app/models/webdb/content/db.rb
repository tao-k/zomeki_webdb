class Webdb::Content::Db < Cms::Content
  default_scope { where(model: 'Webdb::Db') }

  STATE_OPTIONS = [['下書き保存', 'draft'], ['公開保存', 'public']]

  has_one :public_node, -> { public_state.where(model: 'Webdb::Db').order(:id) },
  foreign_key: :content_id, class_name: 'Cms::Node'

  has_many :settings, -> { order(:sort_no) },
    foreign_key: :content_id, class_name: 'Webdb::Content::Setting', dependent: :destroy

  has_many :dbs, foreign_key: :content_id, class_name: 'Webdb::Db', dependent: :destroy

  def public_dbs
    dbs.public_state
  end

  def default_map_position
    site.map_coordinate.to_s.split(',').map(&:strip)
  end


end