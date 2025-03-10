# frozen_string_literal: true

module Fx
  module Sequence
    module CommandRecorder
      def create_sequence(*args)
        record(:create_sequence, args)
      end

      def drop_sequence(*args)
        record(:drop_sequence, args)
      end

      def invert_create_function(args)
        [:drop_function, args]
      end
    end
  end
end
