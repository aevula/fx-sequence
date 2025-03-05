# frozen_string_literal: true

require 'fx/sequence/adapters/postgres/sequences'

module Fx
  module Sequence
    module Adapters
      class Postgres < ::Fx::Adapters::Postgres
        def sequences
          Sequences.all(connection)
        end

        def create_sequence(sql_definition)
          execute(sql_definition)
        end

        def drop_sequence(name)
          execute("DROP SEQUENCE #{name};")
        end
      end
    end
  end
end
