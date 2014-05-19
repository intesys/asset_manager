module AssetManager
  module ApplicationHelper
    def am_title(header, sub_header = nil)
      safe_header = h(header.to_s.truncate(100, separator: ' '))
      content_for(:title) { safe_header }
      safe_header = content_tag(:h1, raw(safe_header))
    end
  end
end
