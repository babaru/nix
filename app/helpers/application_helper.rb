module ApplicationHelper
  include ::Tida::Renderers::ComponentRenderer
  include ::Tida::Metis::SpotPickerRenderHelper
  include ::Tida::Metis::SpaceHelper

  def date_selector(args)
    render :partial => "layouts/date_picker", :locals => {:args => args}
  end

  def truncate_u(text, length = 30, truncate_string = "")
    if text.nil?
      return truncate_string
    end
    l = 0
    char_array = text.unpack("U*")
    char_array.each_with_index do |c, i|
      l = l + (c<127 ? 0.5 : 1)
      if l >= length
        return char_array[0..i].pack("U*") + (i < char_array.length - 1 ? truncate_string : "")
      end
    end
    text
  end
end
