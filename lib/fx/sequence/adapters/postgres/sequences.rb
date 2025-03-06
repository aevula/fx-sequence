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
              JOIN pg_namespace pn ON
                ps.relnamespace = pn.oid
              LEFT JOIN pg_depend pd ON
                pd.objid = ps.oid AND
                pd.classid = 'pg_class'::regclass AND
                pd.deptype = 'a'
              LEFT JOIN pg_class pt ON
                pd.refobjid = pt.oid
              LEFT JOIN pg_attribute pa ON
                pa.attrelid = pt.oid AND
                pa.attnum = pd.refobjsubid
              LEFT JOIN pg_constraint pc ON
                pc.conrelid = pt.oid AND
                pa.attnum = ANY(pc.conkey) AND
                pc.contype = 'p'
            WHERE
                pn.nspname = 'public' AND
                ps.relkind = 'S' AND
                pc.oid IS NULL;
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
