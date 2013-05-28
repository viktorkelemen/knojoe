module ApplicationHelper
  # For generating time tags calculated using jquery.timeago
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(title: time.getutc.iso8601)) if time
  end

  def absolute_css_classes
    %W[
      #{controller_name}_controller
      #{action_name}_action
    ]
  end
end
