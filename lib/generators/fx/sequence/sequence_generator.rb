# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Fx
  module Generators
    class SequenceGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      class_option :migration, type: :boolean
      class_option :exact_name, type: :boolean, default: false, description: 'Use exact name without \'seq\' suffix'

      def self.next_migration_number(dir)
        ::ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def create_sequences_directory
        return if sequence_definition_path.exist?

        empty_directory(sequence_definition_path)
      end

      def create_sequence_definition
        if creating_new_sequence?
          create_file(definition.path, default_sql_definition)
        else
          copy_file(previous_definition.full_path, definition.full_path)
        end
      end

      def create_migration_file
        return if skip_migration_creation?

        migration_template('db/migrate/create_sequence.erb', "db/migrate/create_sequence_#{sequence_name}.rb")
      end

      no_tasks do
        def previous_version
          @previous_version ||= Dir.entries(sequence_definition_path)
                                   .map { |name| extract_version(name) }
                                   .max
        end

        def version
          @version ||= previous_version.next
        end

        def activerecord_migration_class
          if ActiveRecord::Migration.respond_to?(:current_version)
            "ActiveRecord::Migration[#{ActiveRecord::Migration.current_version}]"
          else
            'ActiveRecord::Migration'
          end
        end

        def formatted_name
          name = singular_name.include?('.') ? "\"#{singular_name}\"" : ":#{singular_name}"
          sequence_name(name)
        end
      end

      private

      def sequence_definition_path
        @sequence_definition_path ||= Rails.root.join(*%w[db sequences])
      end

      def version_regex; end

      def extract_version(name)
        Integer(/\A#{sequence_name}_v(?<version>\d+)\.sql\z/.match(name).try(:[], 'version'), 10)
      rescue ArgumentError
        0
      end

      def creating_new_sequence?
        previous_version.zero?
      end

      def definition
        Fx::Sequence::Definition.sequence(name: sequence_name, version: version)
      end

      def previous_definition
        Fx::Sequence::Definition.sequence(name: sequence_name, version: previous_version)
      end

      def skip_migration_creation?
        !migration
      end

      def migration
        options[:migration] != false
      end

      def default_sql_definition
        <<~SQL
          CREATE SEQUENCE #{sequence_name};
        SQL
      end

      def sequence_name(name = file_name)
        options[:exact_name] ? name : "#{name}_seq"
      end
    end
  end
end
