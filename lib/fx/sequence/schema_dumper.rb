# frozen_string_literal: true

module Fx
  module Sequence
    module SchemaDumper
      def tables(stream)
        sequences(stream)
        empty_line(stream)

        super
      end

      private

      def empty_line(stream)
        stream.puts if dumpable_sequences_in_database.any?
      end

      def sequences(stream)
        dumpable_sequences_in_database.each do |sequence|
          stream.puts(sequence.to_schema)
        end
      end

      def dumpable_sequences_in_database
        @dumpable_sequences_in_database ||= Fx::Sequence.database.sequences
      end
    end
  end
end
