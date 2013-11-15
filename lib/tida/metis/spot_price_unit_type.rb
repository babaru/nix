module Tida
  module Metis
    class SpotPriceUnitType < ::Settingslogic
      source "#{Rails.root}/config/enums/spot_price_unit_types.yml"
      namespace Rails.env
    end
  end
end
