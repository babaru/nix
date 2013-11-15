module Tida
  module Metis
    class SpotPicker
      attr_reader :selected_medium,
        :selected_channel,
        :selected_spot_category,
        :selected_unit_type,
        :selected_spots,
        :selected_unit_type_name,
        :spots_query_clause,
        :unit_types,
        :spot_categories,
        :channels,
        :picker_params

      def initialize(options, session = nil)
        @unit_types = ['day', 'cpm', 'cpc']
        @spots_query_clause = 'medium_id=0'
        @picker_params = {}
        session[:spot_picker] = {} if session
        where_clause = []
        unit_type_query_string = nil

        if options[:sp_selected_medium_id]
          @selected_medium = Medium.find options[:sp_selected_medium_id]
          @channels = @selected_medium.channels
          unit_type_query_string = "medium_id = #{@selected_medium.id}"

          if options[:sp_selected_channel_id]
            @selected_channel = Channel.find options[:sp_selected_channel_id]
            unit_type_query_string = "#{unit_type_query_string} and channel_id=#{@selected_channel.id}"
          end

          if options[:sp_selected_unit_type]
            @selected_unit_type = options[:sp_selected_unit_type] if options[:sp_selected_unit_type]
          end

          where_clause << "medium_id=#{@selected_medium.id}" if @selected_medium
          where_clause << "channel_id=#{@selected_channel.id}" if @selected_channel

          if @selected_unit_type
            if @selected_unit_type == 'day'
              where_clause << "unit like '%天%'"
            elsif @selected_unit_type == 'cpm'
              where_clause << "(unit like '%CPM%' or unit like '%cpm%')"
            elsif @selected_unit_type == 'cpc'
              where_clause << "(unit like '%CPC%' or unit like '%CPC%')"
            end

            @selected_unit_type_name = I18n.t("activerecord.attributes.spot.unit_type.#{@selected_unit_type}")
          end

          @spot_categories = @selected_medium.spot_categories if @selected_medium

          if options[:sp_selected_spot_category_id]
            @selected_spot_category = SpotCategory.find options[:sp_selected_spot_category_id]
          end

          if @selected_spot_category
            where_clause << "spot_category_id=#{@selected_spot_category.id}"
          end

          if session
            session[:spot_picker][:sp_selected_medium_id] = @selected_medium.id
            session[:spot_picker][:sp_selected_channel_id] = @selected_channel.id if @selected_channel
            session[:spot_picker][:sp_selected_unit_type] = @selected_unit_type if @selected_unit_type
            session[:spot_picker][:sp_selected_spot_category_id] = @selected_spot_category.id if @selected_spot_category
          end

          @spots_query_clause = where_clause.join(' and ')
        end
      end
    end
  end
end
