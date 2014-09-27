require 'statsample-glm/glm/base'

module Statsample
  module GLM

    class Poisson < Statsample::GLM::Base

      def initialize data_set, dependent, opts={}
        super data_set, dependent, opts
      end

      def to_s
        "Statsample::GLM::Poisson"
      end
    end
  end
end
