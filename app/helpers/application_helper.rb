module ApplicationHelper
  include ::Tida::Renderers::ComponentRenderer
  include ::Tida::Metis::SpotPickerRenderHelper
  include ::Tida::Metis::SpaceHelper

  def date_selector(args)
    render :partial => "layouts/date_picker", :locals => {:args => args}
  end
end
