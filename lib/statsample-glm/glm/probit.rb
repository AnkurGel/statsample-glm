require 'statsample-glm/glm/base'

module Statsample
  module GLM
    class Probit < Statsample::GLM::Base
      
      def initialize data_set, dependent, opts={}
        super data_set, dependent, opts
      end

      def to_s
        "Statsample::GLM::Probit"
      end
    end
  end
end