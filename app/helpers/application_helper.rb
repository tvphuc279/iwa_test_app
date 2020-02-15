module ApplicationHelper
  MAX_STRING_LENGTH = 400

  def default_image_url
    'no_image_icon.png'
  end

  def short_content(content)
    truncate(strip_tags(content.to_s.encode("utf-8").html_safe), length: MAX_STRING_LENGTH, separator: ' ')
  end

  def human_content(content)
    content.to_s.encode("utf-8").html_safe
  end
end
