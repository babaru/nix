# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #
    primary.item :page_dashboard, t('dashboard'), root_url
    #供应商
    primary.item(
      :page_dashboard,
      Supplier.model_name.human,
      root_url
    )do |supplier_menu|

      # 供应商列表
      # ------------------------------------------------------------------------

      supplier_menu.item(
        :page_suppliers,
        t('model.list', model: Supplier.model_name.human),
        suppliers_path,
        {
          link:
          {
            icon: 'list'
          }
        }
      )
      supplier_menu.item(
          :page_suppliers, nil, nil, link: {divider: true})
      supplier_menu.item(
          :page_suppliers,
          t('model.create', model: Supplier.model_name.human),
          new_supplier_path,
          link:
          {
            icon: 'plus-sign'
          }
        )
    end

    #业务类别
    primary.item(
      :page_business_categories,
      BusinessCategory.model_name.human,
      root_url
    )do |supplier_menu|

      # 1级分类列表
      # ------------------------------------------------------------------------

      supplier_menu.item(
        :page_business_categories,
        t('model.list', model: BusinessCategory.model_name.human),
        business_categories_path,
        {
          link:
          {
            icon: 'list'
          }
        }
      )
      BusinessCategory.first_categories.each do |fc|
        supplier_menu.item(
          "page_business_category_#{fc.id}".to_sym,
          fc.name_cn,
          nil
          )do |sub_menu|
            sub_menu.item(
            "page_business_category_#{fc.id}_item_suppliers".to_sym,
            t('model.list', model: Supplier.model_name.human),
            '/suppliers?first_selected_medium_id='+fc.id.to_s,
            {
              link:
              {
                icon: 'folder-close'
              }
            })
            fc.children.each do |cfc|
              sub_menu.item(
              "page_business_category_#{cfc.id}".to_sym,
              cfc.name_cn,
              nil
              )do |th_menu|
                th_menu.item(
                "page_business_category_#{cfc.id}_item_suppliers".to_sym,
                t('model.list', model: Supplier.model_name.human),
                '/suppliers?first_selected_medium_id='+fc.id.to_s+'&second_selected_medium_id='+cfc.id.to_s,
                {
                  link:
                  {
                    icon: 'folder-close'
                  }
                })
                th_menu.item(
                :page_suppliers, nil, nil, link: {divider: true})
                th_menu.item(
                :page_suppliers,
                t('model.edit', model: BusinessCategory.model_name.human),
                edit_business_category_path(cfc),
                link:
                {
                  icon: 'pencil'
                })
              end
            end
            sub_menu.item(
            :page_suppliers, nil, nil, link: {divider: true})
            sub_menu.item(
            :page_suppliers,
            t('model.edit', model: BusinessCategory.model_name.human),
            edit_business_category_path(fc),
            link:
            {
              icon: 'pencil'
            })
          end
      end
      supplier_menu.item(
          :page_business_categories, nil, nil, link: {divider: true})
      supplier_menu.item(
          :page_business_categories,
          t('model.create', model: BusinessCategory.model_name.human),
          new_business_category_path,
          link:
          {
            icon: 'plus-sign'
          }
        )
    end

    #用户
    primary.item(
      :page_dashboard,
      User.model_name.human,
      root_url
    )do |supplier_menu|


      supplier_menu.item(
        :page_users,
        t('model.list', model: User.model_name.human),
        users_path,
        {
          link:
          {
            icon: 'list'
          }
        }
      )
      supplier_menu.item(
          :page_users, nil, nil, link: {divider: true})
      supplier_menu.item(
          :page_users,
          t('model.create', model: User.model_name.human),
          new_user_path,
          link:
          {
            icon: 'plus-sign'
          }
        )
    end

    # Add an item which has a sub navigation (same params, but with block)
    # primary.item :key_2, 'name', url, options do |sub_nav|
      # Add an item to the sub navigation (same params again)
      # sub_nav.item :key_2_1, 'name', url, options
    # end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end
