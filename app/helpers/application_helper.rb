module ApplicationHelper
  def render_page_title(page_title)
    title = page_title ? "#{page_title} | #{SITE_NAME}" : SITE_NAME rescue "SITE_NAME"
    content_tag("title", title)
  end
  
  def render_h1(page_title)
    title = @page_title || "Talk Plus"
    link_to(title, root_path)
  end
end
