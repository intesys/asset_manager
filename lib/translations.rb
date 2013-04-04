#
# quando si rende un modello Globalized occorre aggiungere al modello
# - accepts_nested_attributes_for :translations
# nel caso si vogliano gestire dei modelli legati alla translation (es. photo) occorre
# - translates :photos
# - translation_class.has_many :photos, :as => :owner, :dependent => :destroy
# - translation_class.accepts_nested_attributes_for :photos, :reject_if => lambda { |a| a[:asset].blank? && a[:title].blank? }, :allow_destroy => true#
#
# in active_admin aggiungere
# - form :partials => "form"

# - controller do
#     before_filter :resource_before_filter
#
#     def resource_before_filter
#       @locales = @branch.languages.map(&:identifier)
#       if params[:id]
#         @contact_category = ContactCategory.find(params[:id])
#         @active_translations = @contact_category.translations_for_locales(@locales)
#       end
#     end
#
#     def new
#       @contact_category = ContactCategory.new
#       @locales.each do |locale|
#         translation = @contact_category.translations.build(:locale => locale)
#         translation.photos.build #nel caso ci siano delle photo in translation
#         @active_translations = @contact_category.translations
#       end
#     end
#     def edit  # serve solo per gestire le relazioni in translation (es. photos)
#       @active_translations.each do |translation|
#         translation.photos.build
#       end
#     end

#   end

module AssetManager
  module Translations
    #extend ActiveSupport::Concern

    def self.included(base)
      base.class_eval do
        scope :sorted_by_translated, lambda { |field|
          #if respond_to?(:root)
          #  puts "=== ordino con sort"
          #  with_translations(Globalize.fallbacks).all.sort!{|x,y|
          #    x.send(field) <=> y.send(field)
          #  }
          #else
            with_translations(Globalize.fallbacks).order(translations_table_name + '.' + field.to_s)
          #end
        }
      end
    end

    def translations_for_locales(locales)
      #object = self.class.with_translations.with_locales(locales).find id
      #locales_to_build = locales - object.translations.map(&:locale)
      #locales_to_build.map do |locale|
      #  object.translations.build :locale => locale
      #end
      #object.translations
      translations_for = []
      #puts "=== before #{self.translations.map(&:locale)} #{self.translations.count}"
      #puts "=== locales #{locales.inspect}"
      locales.map do |locale|
        translations_for << self.translation_for(locale)
        #if self.translations.map(&:locale).include? locale
        #  #puts "=== #{locale} presente"
        #else
        #  #puts "=== build translation for #{locale}"
        #  self.translation_for(locale)
        #end
      end
      #puts "=== after #{self.translations.map(&:locale)} #{self.translations.count}"
      translations_for
      #self.translations
    end

  end
end
