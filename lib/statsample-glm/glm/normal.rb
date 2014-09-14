require 'statsample-glm/glm/base'

module Statsample
  module GLM

    class Normal < Statsample::GLM::Base

      def initialize data_set, dependent, opts={}
        super data_set, dependent, opts
      end

      def to_s
        "Statsample::GLM::Normal"
      end
    end
  end
end