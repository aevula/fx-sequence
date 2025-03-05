# frozen_string_literal: true

module Fx
  module Sequence
    module Statements
      def create_sequence(name, **options)
        version = options.fetch(:version, 1)
        sql_definition = options[:sql_definition]

        raise(ArgumentError, 'version or sql_definition must be specified') if version.nil? && sql_definition.nil?

        sql_definition = sql_definition.strip_heredoc if sql_definition
        sql_definition ||= Fx::Sequence::Definition.sequence(name: name, version: version).to_sql

        Fx::Sequence.database.create_sequence(sql_definition)
      end

      def drop_sequence(name, _ = {})
        Fx::Sequence.database.drop_sequence(name)
      end
    end
  end
end
