# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Post.destroy_all
20.times do |n|
  Post.create(title: "Title post #{(n + 1)}")
end

# Asset Categories
AssetManager::AssetCategory.destroy_all
5.times do |n|
  AssetManager::AssetCategory.create(title: "Asset Category #{n + 1}")
end

files = Dir['/home/web/shared/img/*']
tags = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)

# Assets
AssetManager::Asset.destroy_all
150.times do |n|
  # Creazione asset
  a = AssetManager::Asset.create(
    title: "Title #{n + 1}",
    description: "Description #{n + 1}",
    asset_category_id: AssetManager::AssetCategory.first(offset: rand(AssetManager::AssetCategory.count)).id,
    tag_list: tags.sample(2),
    public: true
  )
  puts "Create: #{a.id} ============"
  # Creazione asset instances
  if a.public
    puts 'Public'
    a.asset_public_instances << AssetManager::AssetPublicInstance.create(
      instance_context: AssetManager::AssetInstance.instance_context_all,
      file: File.open(files.sample)
    )
    puts "File: #{a.asset_public_instances.first.file}"
    a.save
  else
    puts 'NOT Public'
    if rand(3) % 2 == 0
      puts '4 All'
      a.asset_private_instances << AssetManager::AssetPrivateInstance.create(
        instance_context: AssetManager::AssetInstance.instance_context_all,
        file: File.open(files.sample)
      )
      puts "File: #{a.asset_private_instances.first.file}"
      a.save
    else
      ics = AssetManager::AssetInstance.instance_contexts
      puts "4 #{ics.inspect} ==="
      n = rand(ics.size)
      ics.sample(n).each do |locale|
        a.asset_private_instances << AssetManager::AssetPrivateInstance.create(
          instance_context: locale,
          file: File.open(files.sample)
        )
        puts "File: #{a.asset_private_instances.last.file}"
        a.save
      end
    end
  end
end
