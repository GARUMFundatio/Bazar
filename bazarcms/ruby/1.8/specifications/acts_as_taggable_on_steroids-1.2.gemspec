# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_taggable_on_steroids}
  s.version = "1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Viney"]
  s.date = %q{2010-01-01}
  s.description = %q{Rails plugin that is based on acts_as_taggable by DHH but includes extras such as tests, smarter tag assignment, and tag cloud calculations.}
  s.email = %q{jonathan.viney@gmail.com}
  s.files = ["acts_as_taggable_on_steroids.gemspec", "CHANGELOG", "generators/acts_as_taggable_migration/acts_as_taggable_migration_generator.rb", "generators/acts_as_taggable_migration/templates/migration.rb", "init.rb", "lib/acts_as_taggable.rb", "lib/acts_as_taggable_on_steroids.rb", "lib/tag.rb", "lib/tag_list.rb", "lib/tagging.rb", "lib/tags_helper.rb", "MIT-LICENSE", "Rakefile", "README", "test/abstract_unit.rb", "test/acts_as_taggable_test.rb", "test/database.yml", "test/fixtures/magazine.rb", "test/fixtures/magazines.yml", "test/fixtures/photo.rb", "test/fixtures/photos.yml", "test/fixtures/post.rb", "test/fixtures/posts.yml", "test/fixtures/special_post.rb", "test/fixtures/subscription.rb", "test/fixtures/subscriptions.yml", "test/fixtures/taggings.yml", "test/fixtures/tags.yml", "test/fixtures/user.rb", "test/fixtures/users.yml", "test/schema.rb", "test/tag_list_test.rb", "test/tag_test.rb", "test/tagging_test.rb", "test/tags_helper_test.rb"]
  s.homepage = %q{http://github.com/jviney/acts_as_taggable_on_steroids}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{acts_as_taggable_on_steroids}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Rails plugin that is based on acts_as_taggable by DHH but includes extras such as tests, smarter tag assignment, and tag cloud calculations.}
  s.test_files = ["test/abstract_unit.rb", "test/acts_as_taggable_test.rb", "test/database.yml", "test/fixtures/magazine.rb", "test/fixtures/magazines.yml", "test/fixtures/photo.rb", "test/fixtures/photos.yml", "test/fixtures/post.rb", "test/fixtures/posts.yml", "test/fixtures/special_post.rb", "test/fixtures/subscription.rb", "test/fixtures/subscriptions.yml", "test/fixtures/taggings.yml", "test/fixtures/tags.yml", "test/fixtures/user.rb", "test/fixtures/users.yml", "test/schema.rb", "test/tag_list_test.rb", "test/tag_test.rb", "test/tagging_test.rb", "test/tags_helper_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
