#encoding: utf-8
module Tida
  module Metis
    module ExcelParsers
      module SpotPlans
        class CaratParser
          class << self
            def parse!(client_id, user_id, excel_file)
              Spreadsheet.open excel_file do |excel|
                ws = excel.worksheet(0)
                master_plan_data = {}
                medium_name = nil
                0.upto(excel.worksheet(0).last_row_index) do |index|
                  if index == 6
                    get_master_plan_name(master_plan_data, ws.row(index))
                  end
                  if index > 13
                    medium_name = get_medium_name(ws.row(index), medium_name)
                    get_master_plan_item(master_plan_data, medium_name, ws.row(index))
                  end
                end

                # Rails.logger.debug master_plan_data
                MasterPlan.transaction do
                  project = Project.find_by_name_and_client_id(master_plan_data[:name], client_id) || Project.create!({name: master_plan_data[:name], client_id: client_id, created_by_id: user_id})
                  master_plan = MasterPlan.create!({name: master_plan_data[:name], project_id: project.id, client_id: client_id, created_by_id: user_id, is_readonly: true})
                  master_plan_data[:master_plan_items].each do |item_data|
                    item_data[:master_plan_id] = master_plan.id
                    medium = Website.where('name like ?', item_data[:medium_name]).first
                    Rails.logger.error "Not found medium named #{item_data[:medium_name]}" if medium.nil?
                    item_data[:medium_id] = medium.id if medium
                    MasterPlanItem.create!(item_data)
                  end

                  Rails.logger.info "Succeed to create master plan #{master_plan.id}"
                end
              end
            end

            private

            def get_master_plan_name(mp, row)
              title = row[1]
              title = title.gsub('Product:', '').strip if title
              mp[:name] = title #TODO add unique name
            end

            def get_medium_name(row, medium_name)
              return row[2].gsub(/\s+/, ';').split(';')[0] unless row[2].nil?
              medium_name
            end

            def get_master_plan_item(mp, medium_name, row)
              mpi = {}
              mpi[:medium_name] = medium_name
              mpi[:channel_name] = row[3]
              mpi[:position_name] = row[4]
              mpi[:material_format] = row[5]
              mpi[:pv_tracking] = row[6]
              mpi[:click_tracking] = row[7]
              mpi[:link_to_official_site] = row[8]
              mpi[:mr_deadline] = row[9]
              mpi[:est_imp] = row[10]
              mpi[:est_clicks] = row[11]
              mpi[:est_total_imp] = row[12]
              mpi[:est_total_clicks] = row[13]
              mpi[:est_ctr] = row[14]
              mpi[:est_cpc] = row[15]
              mpi[:est_cpm] = row[16]
              mpi[:days] = row[17]
              mpi[:cpc] = row[18]
              mpi[:unit_rate_card] = row[19]
              mpi[:discount] = row[20]
              mpi[:net_cost] = row[21]
              mpi[:total_rate_card] = row[22]
              mp[:master_plan_items] = [] if mp[:master_plan_items].nil?
              mp[:master_plan_items] << mpi
            end
          end
        end
      end
    end
  end
end
