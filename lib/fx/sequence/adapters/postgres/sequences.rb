# frozen_string_literal: true

require 'fx/sequence/sequence'

module Fx
  module Sequence
    module Adapters
      class Postgres < ::Fx::Adapters::Postgres
        class Sequences
          SEQUENCES_WITH_DEFINITIONS_QUERY = <<~SQL
            SELECT ps.relname AS name,
                'CREATE SEQUENCE IF NOT EXISTS ' || ps.relname AS definition
            FROM pg_class ps
                JOIN pg_namespace pn ON ps.relnamespace = pn.oid
            WHERE pn.nspname = 'public'
                AND ps.relkind = 'S';
          SQL
          private_constant :SEQUENCES_WITH_DEFINITIONS_QUERY

          def self.all(...)
            new(...).all
          end

          def initialize(connection)
            @connection = connection
          end

          def all
            sequences_from_postgres.map { |sequence| to_fx_sequence(sequence) }
          end

          private

          attr_reader :connection

          def sequences_from_postgres
            connection.execute(SEQUENCES_WITH_DEFINITIONS_QUERY)
          end

          def to_fx_sequence(result)
            Fx::Sequence::Sequence.new(result)
          end
        end
      end
    end
  end
end
