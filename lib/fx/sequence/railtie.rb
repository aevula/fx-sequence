# frozen_string_literal: true

require 'rails/railtie'

module Fx
  module Sequence
    class Railtie < Rails::Railtie
      initializer('fx-sequence.load') do
        ActiveSupport.on_load(:active_record) do
          Fx::Sequence.load
        end
      end
    end
  end
end
