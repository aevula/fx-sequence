# frozen_string_literal: true

module Fx
  module Sequence
    class Definition < Fx::Definition
      SEQUENCE = 'sequence'
      private_constant :SEQUENCE

      def self.sequence(name:, version:)
        new(name: name, version: version, type: SEQUENCE)
      end
    end
  end
end
