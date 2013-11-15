module Tida
  module Metis
    class MediaType < ::Settingslogic
      source "#{Rails.root}/config/enums/media_types.yml"
      namespace Rails.env
    end
  end
end
