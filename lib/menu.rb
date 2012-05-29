class Menu
  class Tab
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def initialize(link_name, link_path)
      @link_name = link_name
      @link_path = link_path
    end

    def render(selected, current_account)
      return '' unless (ActionGuard.authorized?(current_account, @link_path))
      return content_tag(:li, link(selected))
    end

    private
    def link(selected)
      return link_to(@link_name, @link_path, :class => 'active') if (selected)
      return link_to(@link_name, @link_path)
    end
  end

  def initialize()
    @tabs = []
    @tabs_by_path = {}
  end

  def tab(link_name, link_path, options={:highlight_on => link_path})
    tab = Tab.new(link_name, link_path)
    @tabs << tab
    @tabs_by_path[options[:highlight_on]] = tab
    self
  end

  def render(current_path, current_account=nil)
    selected_key = @tabs_by_path.keys.sort{|x,y| y <=> x}.select {|key| current_path =~ /^#{key}/}.first
    selected_tab = @tabs_by_path[selected_key]
    @tabs.collect {|tab| tab.render(tab == selected_tab, current_account)}.join("\n")
  end
end
