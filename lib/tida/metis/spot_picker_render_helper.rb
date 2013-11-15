module Tida
  module Metis
    module SpotPickerRenderHelper
      def spot_picker_medium_selected_items(spot_picker)
        spot_picker_selected_items(
              :sp_selected_medium_id,
              spot_picker.selected_medium.name,
              {
                sp_selected_spot_category_id: nil,
                sp_selected_channel_id: nil,
                sp_selected_unit_type: nil
              }
            ) if spot_picker.selected_medium
      end

      def spot_picker_channel_selected_items(spot_picker)
        spot_picker_selected_items(
              :sp_selected_channel_id,
              spot_picker.selected_channel.name,
              {
                sp_selected_medium_id: spot_picker.selected_medium.nil? ? nil : spot_picker.selected_medium.id,
                sp_selected_spot_category_id: spot_picker.selected_spot_category.nil? ? nil : spot_picker.selected_spot_category.id,
                sp_selected_unit_type: spot_picker.selected_unit_type.nil? ? nil : spot_picker.selected_unit_type
              }
            ) if spot_picker.selected_channel
      end

      def spot_picker_spot_category_selected_items(spot_picker)
        spot_picker_selected_items(
              :sp_selected_spot_category_id,
              spot_picker.selected_spot_category.name,
              {
                sp_selected_medium_id: spot_picker.selected_medium.nil? ? nil : spot_picker.selected_medium.id,
                sp_selected_channel_id: spot_picker.selected_channel.nil? ? nil : spot_picker.selected_channel.id,
                sp_selected_unit_type: spot_picker.selected_unit_type.nil? ? nil : spot_picker.selected_unit_type
              }
            ) if spot_picker.selected_spot_category
      end

      def spot_picker_unit_type_selected_items(spot_picker)
        spot_picker_selected_items(
              :sp_selected_unit_type,
              spot_picker.selected_unit_type_name,
              {
                sp_selected_medium_id: spot_picker.selected_medium.nil? ? nil : spot_picker.selected_medium.id,
                sp_selected_channel_id: spot_picker.selected_channel.nil? ? nil : spot_picker.selected_channel.id,
                sp_selected_spot_category_id: spot_picker.selected_spot_category.nil? ? nil : spot_picker.selected_spot_category.id
              }
            ) if spot_picker.selected_unit_type
      end

      def spot_picker_selected_items(key_name, link_name, opt)
        params.delete(:sp_selected_medium_id)
        params.delete(:sp_selected_channel_id)
        params.delete(:sp_selected_spot_category_id)
        params.delete(:sp_selected_unit_type)

        options = {}
        options = params.merge options
        opt.map {|k, v| options[k] = v if v}
        options[key_name] = nil
        return content_tag(:li, link_to("#{link_name} X", options, class: 'label label-warning'))
      end

      def spot_picker_medium_candidates(spot_picker, medium)
        spot_picker_candidates(
          :sp_selected_medium_id,
          medium.id,
          medium.name,
          {
            sp_selected_medium_id: spot_picker.selected_medium.nil? ? nil : spot_picker.selected_medium.id,
            sp_selected_spot_category_id: spot_picker.selected_spot_category.nil? ? nil : spot_picker.selected_spot_category.id,
            sp_selected_channel_id: spot_picker.selected_channel.nil? ? nil : spot_picker.selected_channel.id,
            sp_selected_unit_type: spot_picker.selected_unit_type.nil? ? nil : spot_picker.selected_unit_type
          })
      end

      def spot_picker_channel_candidates(spot_picker, channel)
        spot_picker_candidates(
          :sp_selected_channel_id,
          channel.id,
          channel.name,
          {
            sp_selected_medium_id: spot_picker.selected_medium.id,
            sp_selected_spot_category_id: spot_picker.selected_spot_category.nil? ? nil : spot_picker.selected_spot_category.id,
            sp_selected_channel_id: spot_picker.selected_channel.nil? ? nil : spot_picker.selected_channel.id,
            sp_selected_unit_type: spot_picker.selected_unit_type.nil? ? nil : spot_picker.selected_unit_type
          })
      end

      def spot_picker_spot_category_candidates(spot_picker, spot_category)
        spot_picker_candidates(
          :sp_selected_spot_category_id,
          spot_category.id,
          spot_category.name,
          {
            sp_selected_medium_id: spot_picker.selected_medium.id,
            sp_selected_spot_category_id: spot_picker.selected_spot_category.nil? ? nil : spot_picker.selected_spot_category.id,
            sp_selected_channel_id: spot_picker.selected_channel.nil? ? nil : spot_picker.selected_channel.id,
            sp_selected_unit_type: spot_picker.selected_unit_type.nil? ? nil : spot_picker.selected_unit_type
          })
      end

      def spot_picker_unit_type_candidates(spot_picker, unit_type)
        spot_picker_candidates(
          :sp_selected_unit_type,
          unit_type,
          t("activerecord.attributes.spot.unit_type.#{unit_type}"),
          {
            sp_selected_medium_id: spot_picker.selected_medium.nil? ? nil : spot_picker.selected_medium.id,
            sp_selected_spot_category_id: spot_picker.selected_spot_category.nil? ? nil : spot_picker.selected_spot_category.id,
            sp_selected_channel_id: spot_picker.selected_channel.nil? ? nil : spot_picker.selected_channel.id,
            sp_selected_unit_type: spot_picker.selected_unit_type.nil? ? nil : spot_picker.selected_unit_type
          })
      end

      def spot_picker_candidates(key_name, value, link_name, opt)
        options = {}
        options = params.merge options
        opt.map {|k, v| options[k] = v if v && k.to_s != key_name.to_s}
        options[key_name] = value
        class_string = ""
        class_string = "active" if value == opt[key_name]
        return content_tag(:li, link_to(link_name, options), class: class_string)
      end
    end
  end
end
