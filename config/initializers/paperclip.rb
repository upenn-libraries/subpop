module Subpop
  class Application < Rails::Application
    # url: "/system/#{Rails.env}/:class/:attachment/:id_partition/:style/:filename"
    # path: ":rails_root/public/system/#{Rails.env}/:class/:attachment/:id_partition/:style/:filename",

    # Use env-specific path if Rails.env != 'production'
    env_string = Rails.env == 'production' ? nil : Rails.env
    paperclip_url = [
      '', 'system', env_string, ':class', ':attachment', ':id_partition',
      ':style', ':filename',
    ].flatten.join '/'

    config.x.subpop.paperclip_url = paperclip_url
    config.x.subpop.paperclip_path = ":rails_root/public#{paperclip_url}"
  end
end