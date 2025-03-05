# frozen_string_literal: true

require './lib/fx/sequence/version'

Gem::Specification.new do |spec|
  spec.name = 'fx-sequence'
  spec.version = Fx::Sequence::VERSION

  spec.summary = 'Extension for fx gem for sequence support'
  spec.description = 'Extension for fx gem for creating, droping and dumping to schema.rb sequences'

  spec.authors = ['@aevula']
  spec.homepage = 'https://github.com/aevula/fx-sequence'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1'

  spec.metadata = {
    'homepage_uri'          => 'https://github.com/aevula/fx-sequence',
    'source_code_uri'       => 'https://github.com/aevula/fx-sequence/tree/master',
    'changelog_uri'         => 'https://github.com/aevula/fx-sequence/tree/master/CHANGELOG.md',
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir['README.md', 'LICENSE.txt', 'CHANGELOG.md', 'lib/**/*', 'Rakefile']

  spec.add_dependency 'fx'

  spec.require_paths = ['lib']
end
