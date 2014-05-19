namespace :asset_manager do

  desc 'Recreate versions'
  task :recreate_versions => :environment do |t|
    recreate_versions
  end

end

private

  def recreate_versions
    # Public
    assets = AssetManager::Asset.where(public: true)
    count = assets.count
    assets.each_with_index do |a, i|
      puts "PUBLIC File #{i+1} of #{count}\n"
      a.asset_public_instances.each do |ai|
        ai.file.recreate_versions! rescue nil
      end
    end

    # Private
    assets = AssetManager::Asset.where(public: false)
    count = assets.count
    assets.each_with_index do |a, i|
      puts "PRIVATE File #{i+1} of #{count}\n"
      a.asset_private_instances.each do |ai|
        ai.file.recreate_versions! rescue nil
      end
    end
  end
