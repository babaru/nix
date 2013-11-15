#encoding: utf-8
module Tida
  module Metis
    module ExcelGenerators
      module SpotPlans
        class CaratGenerator
          LINE_HEIGHT = 17
          FONT_NAME = '微软雅黑'
          FONT_SIZE = 9
          COLUMN_NAMES = [
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
          ]
          COLUMN_NAMES_2 = [
            '', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
          ]

          attr_reader :master_plan_id
          def initialize(master_plan_id)
            @master_plan_id = master_plan_id
          end

          def generate(version)
            master_plan = MasterPlan.find self.master_plan_id
            ap = ::Axlsx::Package.new

            styles = ap.workbook.styles
            table_header_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :bottom},
              border: {style: :thin, color: "00", edges: [:left, :top, :right]}
            })
            table_header_calendar_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            table_header_first_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :bottom},
              border: {style: :thin, color: "00", edges: [:left, :top]}
              })
            table_header_last_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:right, :top, :bottom]}
              })

            table_header_cell2 = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :top},
              border: {style: :thin, color: "00", edges: [:left, :bottom, :right]}
            })
            table_header_calendar_cell2 = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            table_header_calendar_weekend_cell2 = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              bg_color: "DDDDDD",
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            table_header_first_cell2 = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :top},
              border: {style: :thin, color: "00", edges: [:left, :bottom]}
              })
            table_header_last_cell2 = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:right, :top, :bottom]}
              })
            table_header_last_weekend_cell2 = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              bg_color: "DDDDDD",
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:right, :top, :bottom]}
              })

            global_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :left, vertical: :center}
            })

            center_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            left_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :left, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            right_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :right, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            old_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              bg_color: "FFFF00"
            })
            on_house_center_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              fg_color: "FF0000"
            })
            on_house_left_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :left, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              fg_color: "FF0000"
            })
            on_house_right_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :right, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              fg_color: "FF0000"
            })
            sub_total_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              bg_color: "DDDDDD"
            })
            sub_total_on_house_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              bg_color: "DDDDDD"
            })
            total_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              bg_color: "00CCFF"
            })
            currency_cell = styles.add_style({
              format_code: "¥#,##0;[Red]¥-#,##0",
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            currency_on_house_cell = styles.add_style({
              format_code: "¥#,##0;[Red]¥-#,##0",
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              fg_color: "FF0000"
            })
            number_cell = styles.add_style({
              format_code: "#,##0",
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            number_on_house_cell = styles.add_style({
              format_code: "#,##0",
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: false,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]},
              fg_color: "FF0000"
            })

            ap.workbook.add_worksheet name: 'Spot Plan' do |sheet|

              # Fill Global Header

              sheet.add_row()
              sheet.add_row([nil, 'Carat Digital Media Spot Plan'], style: [nil, global_cell])
              sheet.add_row([nil, 'Client:', master_plan.client.name], style: [nil, global_cell, global_cell])
              sheet.add_row([nil, 'Product:', master_plan.project.name], style: [nil, global_cell, global_cell])
              sheet.add_row([nil, 'Period:', "#{master_plan.project.started_at.strftime('%Y.%m.%d')} - #{master_plan.project.ended_at.strftime('%Y.%m.%d')}"], style: [nil, global_cell, global_cell])
              sheet.add_row([nil, 'Version Date:', Time.now.strftime('%Y-%m-%d')], style: [nil, global_cell, global_cell])
              sheet.add_row([nil, 'Prepared By:'], style: [nil, global_cell])
              sheet.add_row([nil, 'Job Code:'], style: [nil, global_cell])
              sheet.add_row()

              # Fill Table Header

              table_headers = [
                nil,
                "Media Type",
                "Site",
                "Channel",
                "Position",
                "Material Format",
                "PV Tracking",
                "Click Tracking",
                "Link to Office Site",
                "MR Deadline",
                "Est. Imp/day",
                "Est. Clicks/day",
                "Est. Total Imp",
                "Est. Total Clicks",
                "Est. CTR",
                "Est. CPC",
                "Est. CPM",
                "Est. Days",
                "Est. CPM",
                "Leads",
                "Unit Rate Card",
                "Discount",
                "Nest Cost",
                "Total Rate Card"
              ]

              table_calendar_days = [
                nil,
                "媒体类型",
                "网站",
                "频道",
                "点位",
                "素材尺寸格式",
                "PV监测",
                "Click监测",
                "可否外链",
                "素材提交时间",
                "预估曝光/天",
                "预估点击/天",
                "预估曝光量",
                "预估点击数",
                "预估点击率",
                "预估点击成本",
                "预估千次曝光成本",
                "投放日数",
                "量",
                "",
                "单位刊例价",
                "折扣",
                "净价",
                "总刊例价"
              ]

              # table_headers.length.times {|n| table_calendar_days << nil}

              description_column_count = table_headers.length - 2

              calendar_column_index = table_headers.length

              months = master_plan.project.months
              days = master_plan.project.days

              # Rails.logger.debug "months: #{months}"
              # Rails.logger.debug "days: #{days}"

              table_calendar_days_header_styles = [nil, table_header_first_cell2, Array.new(description_column_count, table_header_cell2)].flatten

              month_segs = []
              total_day_count = 0
              months.each_with_index do |month, m_index|
                key = "#{month[:year]}#{sprintf('%02d', month[:month])}"
                table_headers << "#{month[:year]}-#{sprintf('%02d', month[:month])}"
                col_count = 0
                days[key].each_with_index do |day, index|
                  if m_index == 0
                    if day && day > 0
                      table_headers << nil if index + 1 < days[key].length
                      day_number = index + 1
                      table_calendar_days << day_number
                      date = Date.new(month[:year], month[:month], day_number)
                      if date.wday == 0 || date.wday == 6
                        if m_index == months.length - 1 && index == days[key].length - 1 # last cell
                          table_calendar_days_header_styles << table_header_last_weekend_cell2
                        else
                          table_calendar_days_header_styles << table_header_calendar_weekend_cell2
                        end
                      else
                        if m_index == months.length - 1 && index == days[key].length - 1 # last cell
                          table_calendar_days_header_styles << table_header_last_cell2
                        else
                          table_calendar_days_header_styles << table_header_calendar_cell2
                        end
                      end
                      col_count += 1 if index + 1 < days[key].length && index > 0
                    end
                  else
                    table_headers << nil if index > 0
                    day_number = index + 1
                    table_calendar_days << day_number
                    date = Date.new(month[:year], month[:month], day_number)
                      if date.wday == 0 || date.wday == 6
                        if m_index == months.length - 1 && index == days[key].length - 1 # last cell
                          table_calendar_days_header_styles << table_header_last_weekend_cell2
                        else
                          table_calendar_days_header_styles << table_header_calendar_weekend_cell2
                        end
                      else
                        if m_index == months.length - 1 && index == days[key].length - 1 # last cell
                          table_calendar_days_header_styles << table_header_last_cell2
                        else
                          table_calendar_days_header_styles << table_header_calendar_cell2
                        end
                      end
                    col_count += 1 if day > 0 && index > 0
                  end
                end
                month_segs << col_count
                total_day_count += days[key].length
              end

              # Rails.logger.debug("total_day_count: #{total_day_count}")

              table_header_styles = [nil, table_header_first_cell, Array.new(description_column_count, table_header_cell), Array.new(table_headers.length - 3 - description_column_count, table_header_calendar_cell), table_header_last_cell].flatten
              row = sheet.add_row(table_headers, style: table_header_styles)
              row.height = 20

              row = sheet.add_row(table_calendar_days, style: table_calendar_days_header_styles)
              row.height = 20

              0.upto(calendar_column_index - 1) do |n|
                # sheet.merge_cells("#{get_column_name(n)}#{row.index}:#{get_column_name(n)}#{row.index + 1}")
              end

              month_segs.each_with_index do |seg, index|
                if index == 0
                  sheet.merge_cells("#{get_column_name(calendar_column_index)}#{row.index}:#{get_column_name(calendar_column_index + seg + 1)}#{row.index}")
                  calendar_column_index = calendar_column_index + seg + 2
                else
                  sheet.merge_cells("#{get_column_name(calendar_column_index)}#{row.index}:#{get_column_name(calendar_column_index + seg)}#{row.index}")
                  calendar_column_index = calendar_column_index + seg + 1
                end
              end

              # Fill records

              start_index = row.index + 2
              media_type_start_index = row.index + 2

              sub_total_rows = []

              master_plan.medium_master_plans.each do |medium_master_plan|
                medium_master_plan.master_plan_items.order('is_on_house').each do |item|
                  if item.is_on_house?
                    row = fill_data_row(sheet, item, months, days, center_cell, on_house_left_cell, on_house_center_cell, currency_on_house_cell, number_on_house_cell, old_cell, version)
                  else
                    row = fill_data_row(sheet, item, months, days, center_cell, left_cell, center_cell, currency_cell, number_cell, old_cell, version)
                  end
                end
                sheet.merge_cells("#{get_column_name(2)}#{start_index}:#{get_column_name(2)}#{row.index + 1}")
                row = fill_sub_total_row(sheet, medium_master_plan.bonus_ratio, start_index, row.index + 1, total_day_count, center_cell, sub_total_cell, sub_total_on_house_cell)
                sub_total_rows << row.index + 1
                start_index = row.index + 2
              end

              sheet.merge_cells("#{get_column_name(1)}#{media_type_start_index}:#{get_column_name(1)}#{row.index + 1}")

              row = fill_total_row(sheet, row.index + 1, sub_total_rows, total_day_count, total_cell)

              sheet.column_widths(2, 15, 12, 12, 35, 24, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
            end

            root_folder = File.join Rails.root, 'tmp/spot_plans'
            FileUtils.mkdir_p root_folder unless File.exist?(root_folder)
            result_file = File.join root_folder, "#{master_plan.client.name} #{master_plan.project.name} #{master_plan.name} #{Time.now.strftime('%Y%m%d')} #{Time.now.strftime('%H%M%S')}.xlsx"
            ap.serialize result_file
            Rails.logger.info "* Created excel file succeed: #{result_file}"

            # box_uploader = ::BackOffice::Box::Uploader.new
            # box_uploader.upload result_file, "#{Settings.file_system.box.sina_weibo_report_root}/#{sina_weibo_url_package.name}"
            result_file
          end

          private

          def get_column_name(n)
            r = n % 26
            l = n / 26
            Rails.logger.debug "l: #{l} r: #{r}"
            first_char = COLUMN_NAMES_2[l]
            second_char = COLUMN_NAMES[r]
            "#{first_char}#{second_char}"
          end

          def fill_total_row(sheet, end_row_index, sub_total_rows, calendar_column_count, total_cell)
            sp12 = "+#{get_column_name(12)}"
            sp13 = "+#{get_column_name(13)}"
            sp22 = "+#{get_column_name(22)}"
            row = sheet.add_row([nil, 'Total', Array.new(8, nil), '-', '-',
              "=#{get_column_name(12)}#{sub_total_rows.join(sp12)}",
              "=#{get_column_name(13)}#{sub_total_rows.join(sp13)}",
              "=#{get_column_name(13)}#{end_row_index + 1}/#{get_column_name(12)}#{end_row_index + 1}",
              "=#{get_column_name(22)}#{end_row_index + 1}/#{get_column_name(13)}#{end_row_index + 1}",
              "=#{get_column_name(22)}#{end_row_index + 1}/#{get_column_name(13)}#{end_row_index + 1}*1000",
              '-', '-', nil, '-', '-',
              "=#{get_column_name(22)}#{sub_total_rows.join(sp22)}", nil,
              Array.new(calendar_column_count, nil)].flatten,
              style: [nil, Array.new(23 + calendar_column_count, total_cell)].flatten)
            sheet.merge_cells("#{get_column_name(1)}#{row.index + 1}:#{get_column_name(3)}#{row.index + 1}")
            sheet.merge_cells("#{get_column_name(24)}#{row.index + 1}:#{get_column_name(23 + calendar_column_count)}#{row.index + 1}")
            row
          end

          def fill_sub_total_row(sheet, on_house_ratio, start_row_index, end_row_index, calendar_column_count, center_cell, sub_total_cell, sub_total_on_house_cell)
            row = sheet.add_row([nil, nil, 'Sub Total', Array.new(7, nil), '-', '-',
              "=SUM(#{get_column_name(12)}#{start_row_index}:#{get_column_name(12)}#{end_row_index})",
              "=SUM(#{get_column_name(13)}#{start_row_index}:#{get_column_name(13)}#{end_row_index})",
              "=#{get_column_name(13)}#{end_row_index + 1}/#{get_column_name(12)}#{end_row_index + 1}",
              "=#{get_column_name(22)}#{end_row_index + 1}/#{get_column_name(13)}#{end_row_index + 1}",
              "=#{get_column_name(22)}#{end_row_index + 1}/#{get_column_name(13)}#{end_row_index + 1}*1000",
              "-", "-", nil, '-', '-',
              "=SUM(#{get_column_name(22)}#{start_row_index}:#{get_column_name(22)}#{end_row_index})",
              "Bonus Ratio: #{on_house_ratio}",
              Array.new(calendar_column_count, nil)].flatten,
              style: [nil, center_cell, Array.new(21, sub_total_cell), sub_total_on_house_cell, Array.new(calendar_column_count, sub_total_cell)].flatten)
            sheet.merge_cells("#{get_column_name(2)}#{row.index + 1}:#{get_column_name(3)}#{row.index + 1}")
            sheet.merge_cells("#{get_column_name(24)}#{row.index + 1}:#{get_column_name(23 + calendar_column_count)}#{row.index + 1}")
            row
          end

          def fill_data_row(sheet, master_plan_item, months, days, medium_name_cell, left_cell, center_cell, currency_cell, number_cell, old_cell, version)
            spot_plan_item_cells, spot_plan_item_cells_styles = get_spot_plan_item_cells(master_plan_item, months, days, center_cell, old_cell, version)
            sheet.add_row([nil, '网站',
              master_plan_item.medium_name,
              master_plan_item.channel_name,
              master_plan_item.position_name,
              master_plan_item.material_format,
              Array.new(4, nil),
              master_plan_item.est_imp,
              master_plan_item.est_clicks,
              master_plan_item.est_total_imp,
              master_plan_item.est_total_clicks,
              master_plan_item.est_ctr,
              nil, nil,
              master_plan_item.count,
              nil, nil,
              master_plan_item.unit_rate_card,
              master_plan_item.is_on_house? ? '0%' : "#{master_plan_item.medium_discount * 100}%",
              master_plan_item.is_on_house? ? 0 : master_plan_item.medium_net_cost,
              master_plan_item.unit_rate_card * master_plan_item.count,
              spot_plan_item_cells].flatten,
              style: [nil, medium_name_cell, medium_name_cell, center_cell, left_cell, left_cell, Array.new(4, center_cell),
                Array.new(4, number_cell),
                Array.new(6, center_cell), currency_cell, center_cell, currency_cell, currency_cell, spot_plan_item_cells_styles].flatten)
          end

          def get_spot_plan_item_cells(master_plan_item, months, days, normal_style, old_cell_style, version)
            cells = []
            styles = []
            months.each_with_index do |month, m_index|
              key = "#{month[:year]}#{sprintf('%02d', month[:month])}"
              days[key].each_with_index do |day, index|
                if day && day > 0
                  spi = SpotPlanItem.in_version(master_plan_item.id, version).where(placed_at: Time.parse("#{month[:year]}-#{sprintf('%02d', month[:month])}-#{sprintf('%02d', index + 1)}")).first
                  if spi
                    if spi.new_spot_plan_item_id
                      cells << nil
                      styles << old_cell_style
                    else
                      cells << spi.count
                      styles << normal_style
                    end
                  else
                    cells << nil
                    styles << normal_style
                  end
                end
              end
            end
            [cells, styles]
          end
        end
      end
    end
  end
end
