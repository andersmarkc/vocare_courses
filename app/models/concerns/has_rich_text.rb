module HasRichText
  extend ActiveSupport::Concern

  ALLOWED_TAGS = %w[p br strong em u s h2 h3 h4 ul ol li a blockquote code pre].freeze
  ALLOWED_ATTRIBUTES = %w[href title target rel].freeze

  class_methods do
    def sanitize_rich_text(*attrs)
      before_save do
        attrs.each do |attr|
          value = public_send(attr)
          next if value.blank?

          public_send("#{attr}=", HasRichText.sanitize(value))
        end
      end
    end
  end

  def self.sanitize(html)
    sanitized = Rails::HTML5::SafeListSanitizer.new.sanitize(
      html,
      tags: ALLOWED_TAGS,
      attributes: ALLOWED_ATTRIBUTES,
      scrubber: LinkScrubber.new
    )
    sanitized.to_s
  end

  class LinkScrubber < Rails::HTML::PermitScrubber
    def initialize
      super
      self.tags = ALLOWED_TAGS
      self.attributes = ALLOWED_ATTRIBUTES
    end

    def scrub_attribute?(name)
      super
    end

    def scrub(node)
      if node.name == "a"
        href = node["href"].to_s.strip
        if href.match?(/\Ajavascript:/i) || href.match?(/\Adata:/i)
          node.remove_attribute("href")
        end
        node["rel"] = "noopener nofollow"
        node["target"] = "_blank"
      end
      super
    end
  end
end
