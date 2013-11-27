module Tida
  module Renderers
    class NavigationBarRenderer < ::SimpleNavigation::Renderer::Base
      def render(item_container)
        list_content = item_container.items.inject([]) do |list, item|
          list << item_content(item)
        end.join
        content_tag(:div, content_tag(:ul, list_content), {id: "top-navigation-bar"})
      end

      protected

      def item_content(item)
        if include_sub_navigation?(item)
          return render_sub_navigation(item)
        else
          return content_tag :li, tag_for(item)
        end
      end

      def tag_for(item)
        options = options_for(item)
        icon = options.delete(:icon)
        stack_icon = options.delete(:stack_icon)
        content = []
        if stack_icon
          stack_content = []
          stack_content << content_tag(:i, nil, class: "icon-stack-base #{stack_icon[:base]}")
          stack_content << content_tag(:i, nil, class: stack_icon[:icon])
          stack = content_tag(:span, stack_content.join(), class: 'icon-stack')
          content << stack
        else
          content << content_tag(:i, nil, class: icon)
        end
        content << content_tag(:span, item.name)
        link_to content.join(' '), item.url, options
      end

      def render_sub_navigation(parent_item)
        content = []
        content << tag_for_level_1(parent_item)
        content << tag_for_level_2(parent_item)
        content_tag :div, content_tag(:div, content.join(), class: 'accordion-group'), class: 'accordion', id: "accordion_#{parent_item.key}"
      end

      def tag_for_level_1(item)
        item_content = nil
        options = options_for(item)
        icon = options.delete(:icon)

        content = []
        content << content_tag(:i, nil, class: icon) if icon
        content << content_tag(:span, item.name)
        if options[:class] && options[:class].include?('active')
          content << content_tag(:i, nil, class: 'arrow icon-angle-down')
          options[:class] = [options[:class].delete('active'), 'accordion-toggle open'].flatten.compact.join(' ')
        else
          content << content_tag(:i, nil, class: 'arrow icon-angle-left')
          options[:class] = [options[:class], 'accordion-toggle collapsed'].flatten.compact.join(' ')
        end
        options = options.merge('data-toggle' => "collapse", 'data-parent' => "#accordion_#{item.key}")
        item_content = link_to(content.join(' '), "#collapse_#{item.key}", options)

        li_content = content_tag :div, item_content, class: 'accordion-heading'
      end

      def tag_for_level_2(item)
        sub_list_content = item.sub_navigation.items.inject([]) do |list, sub_item|
          options = link_options_for(sub_item)
          icon = options.delete(:icon)
          content = []
          content << content_tag(:i, nil, class: icon) if icon
          content << content_tag(:span, sub_item.name)
          li_content = link_to(content.join(' '), sub_item.url, options)

          if include_sub_navigation?(sub_item)
            list << render_sub_navigation(sub_item)
          else
            list << content_tag(:li, li_content)
          end
        end.join
        sub_list = content_tag(:ul, sub_list_content)
        inner_container = content_tag(:div, sub_list, class: 'accordion-inner')
        if item.selected?
          content_tag(:div, inner_container, {:class => 'accordion-body in collapse active', 'id' => "collapse_#{item.key}"})
        else
          content_tag(:div, inner_container, {:class => 'accordion-body collapse', 'id' => "collapse_#{item.key}"})
        end
      end
    end
  end
end
