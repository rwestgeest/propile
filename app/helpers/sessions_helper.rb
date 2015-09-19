module SessionsHelper
  def session_show_property(name,value)
    return "" if value.nil?
    value = value.strip
    return "" if value.length == 0
    "<tr><td class=\"propertyname\">#{h(name)}</td><td>#{w(value)}</td></tr>".html_safe
  end
  
  def session_show_properties(name,value1,value2)
    value = ""
    value = value1.strip unless value1.nil?
    value = value + " " + value2 unless value2.nil?
    session_show_property(name,value)
  end
end
