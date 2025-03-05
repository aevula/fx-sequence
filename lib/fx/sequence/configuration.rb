# frozen_string_literal: true

module Fx
  module Sequence
    class Configuration < Fx::Configuration
      def initialize
        super
        @database = Fx::Sequence::Adapters::Postgres.new
      end
    end
  end
end
