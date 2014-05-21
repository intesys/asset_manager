$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'intesys_asset_manager/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'intesys_asset_manager'
  s.version     = AssetManager::VERSION
  s.authors     = ['Intesys S.r.l.', 'Federico Bonomi']
  s.email       = ['federico.bonomi@intesys.it']
  s.homepage    = 'http://www.intesys.it/'
  s.summary     = 'Manage your assets in style'
  s.description = %q{An engine to manage your assets. It allows you to
    create/view assets}

  s.files = Dir['{app,config,db,lib,vendor}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']
  s.test_files.reject! { |fn| fn.include? 'dummy' }

  s.add_dependency 'acts-as-taggable-on'
  s.add_dependency 'bootstrap_kaminari'
  s.add_dependency 'carrierwave', '~> 0.10'
  s.add_dependency 'cocoon'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'fancybox2-rails', '>= 0.2.6'
  s.add_dependency 'formtastic-bootstrap'
  s.add_dependency 'globalize', '~> 3.0'
  s.add_dependency 'haml-rails'
  s.add_dependency 'jquery-fileupload-rails'
  s.add_dependency 'jquery-rails', '>= 2.1.4'
  s.add_dependency 'jquery-ui-rails', '>= 3.0.1'
  s.add_dependency 'kaminari'
  s.add_dependency 'meta_search'
  s.add_dependency 'mini_magick'
  s.add_dependency 'rails', '~> 3.2'
  s.add_dependency 'sass-rails', '>= 3.1'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'sqlite3'
end
