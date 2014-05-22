module AssetManager
  module TouchTranslation
    def self.included(base)
      base.class_eval do
        method_name = 'touch_after_save_or_destroy_for_globalized_model'
        self::Translation.class_eval do
          redefine_method(method_name) do
            record = send(:globalized_model)
            record.touch unless record.nil?
          end
          after_save(method_name)
          after_touch(method_name)
          after_destroy(method_name)
        end
      end
    end
  end
end
