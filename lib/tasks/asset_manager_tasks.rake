namespace :asset_manager do

  desc "Recreate versions"
  task :recreate_versions => :environment do |t|
    recreate_versions
  end

end

private

  def recreate_versions
    count = AssetManager::AssetPublicInstance.count
    AssetManager::AssetPublicInstance.all.each_with_index do |ai, i|
      puts "File #{i+1} of #{count}\n"
      ai.file.recreate_versions! rescue nil
    end
  end
