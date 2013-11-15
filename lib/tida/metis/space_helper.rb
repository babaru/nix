module Tida
  module Metis
    module SpaceHelper
      def current_space
        if current_user && current_user.spaces.count > 0 && !current_user.is_sys_admin?
          session[:space_id] = current_user.spaces.first.id unless session[:space_id]
          return Space.find(session[:space_id]) if session[:space_id]
        end
        nil
      end
    end
  end
end
