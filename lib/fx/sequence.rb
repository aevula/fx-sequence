# frozen_string_literal: true

require 'rails'

require 'fx'

require 'fx/sequence/version'
require 'fx/sequence/adapters/postgres'
require 'fx/sequence/command_recorder'
require 'fx/sequence/configuration'
require 'fx/sequence/definition'
require 'fx/sequence/sequence'
require 'fx/sequence/statements'
require 'fx/sequence/schema_dumper'
require 'fx/sequence/railtie'

module Fx
  module Sequence
    def self.load
      ActiveRecord::Migration::CommandRecorder.include(Fx::Sequence::CommandRecorder)
      ActiveRecord::ConnectionAdapters::AbstractAdapter.include(Fx::Sequence::Statements)
      ActiveRecord::SchemaDumper.prepend(Fx::Sequence::SchemaDumper)

      true
    end

    def self.configuration
      @configuration ||= Fx::Sequence::Configuration.new
    end

    def self.database
      configuration.database
    end
  end
end
