module AssetManager
  module AssetInstancesHelper

    def asset_instance_url(resource, version = nil)
      if resource.asset.public
        unless version.nil?
          resource.file.url(version)
        else
          resource.file.url
        end
      else
        "DEVO ANCORA FARE IL CONTROLLER PER GLI ASSET PRIVATI"
      end
    end

    def display_instance_context(resource)
      if resource.is_all?
        display_instance_context_all
      else
        resource.instance_context
      end
    end

    def display_instance_context_all
      raw('&#8659')
    end

  end
end
