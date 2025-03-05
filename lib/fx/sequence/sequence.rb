# frozen_string_literal: true

module Fx
  module Sequence
    class Sequence
      include Comparable

      attr_reader :name, :definition

      delegate :<=>, to: :name

      def initialize(row)
        @name = row.fetch('name')
        @definition = row.fetch('definition')
      end

      def ==(other)
        name == other.name && definition == other.definition
      end

      def to_schema
        <<-SCHEMA
  create_sequence :#{name}, sql_definition: <<-\SQL
      #{definition}
  SQL
        SCHEMA
      end
    end
  end
end
