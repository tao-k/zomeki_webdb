class Webdb::Content::Setting < Cms::ContentSetting

  belongs_to :content, foreign_key: :content_id, class_name: 'Webdb::Content::Db'

  #set_config :book_library_config_sample,
  #  name: '設定サンプル',
  #  form_type: :radio_buttons,
  #  options: [['有効', 'enabled'], ['無効', 'disabled']],
  #  default_value: 'enabled'


end
