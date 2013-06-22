module MessagesHelper

  def parse_emoji(html)
    html
    .gsub(/(:\))/, content_tag(:span, '', class: 'emoji smile'))
    .gsub(/(:\()/, content_tag(:span, '', class: 'emoji worried'))
    .gsub(/(:D)/, content_tag(:span, '', class: 'emoji laugh'))
    .gsub(/(:P)/, content_tag(:span, '', class: 'emoji tongue'))
    .html_safe
  end
end
