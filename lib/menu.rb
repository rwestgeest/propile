module Menu
  module RequestParams
    def request_params_for(path)
      path, parameters = path.split("?")
      controller, action = path.split('#')
      parameters_hash = Hash[ parameters &&  parameters.split("&").map {|key_value| key_value.split('=').map{|e| e.strip }} || [] ]
      parameters_hash['controller'] = controller
      parameters_hash['action'] = action || 'index'
      parameters_hash
    end
  end

  include RequestParams
  def create(router)
    self.class.create(router)
  end

  def self.create(router)
    Base.new(router)
  end

  class Base
    include RequestParams
    class Tab
      include ActionView::Helpers::TagHelper

      def initialize(link_name, link_params, router)
        @link_name = link_name
        @link_parameters = link_params
        @router = router
      end

      def render(selected, current_account)
        return '' unless (ActionGuard.authorized?(current_account, @link_parameters))
        return content_tag(:li, link(selected))
      end

      private
      def link(selected)
        return @router.link_to(@link_name, @link_parameters, :class => 'active') if (selected)
        return @router.link_to(@link_name, @link_parameters)
      end
    end

    def initialize(router)
      @tabs = []
      @tabs_by_path = {}
      @router = router
    end

    def tab(link_name, link_path, options={})
      link_params = request_params_for(link_path)
      tab = Tab.new(link_name, link_params, @router)
      options[:highlight_on] ||= selection_path(link_params)
      @tabs << tab
      @tabs_by_path[options[:highlight_on]] = tab
      self
    end

    def render(current_path, current_account=nil)
      selected_key = @tabs_by_path.keys.sort{|x,y| y <=> x}.select {|key| selection_path(current_path) =~ /^#{key}/}.first
      selected_tab = @tabs_by_path[selected_key]
      @tabs.collect {|tab| tab.render(tab == selected_tab, current_account)}.join("\n")
    end
    def selection_path(request_params)
      result = request_params['controller']
      result += request_params['action'] unless request_params['action'] == 'index'
      result
    end
  end
end
