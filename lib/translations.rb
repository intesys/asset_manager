module AssetManager
  module Translations
    def self.included(base)
      base.class_eval do
        scope :sorted_by_translated, lambda { |field|
          with_translations(Globalize.fallbacks).order(translations_table_name + '.' + field.to_s)
        }
      end
    end

    def translations_for_locales(locales)
      translations_for = []
      locales.map do |locale|
        translations_for << translation_for(locale)
      end
      translations_for
    end
  end
end
