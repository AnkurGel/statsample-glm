require 'statsample-glm/glm/irls/base'

module Statsample
  module GLM
    module IRLS
      class Logistic < Statsample::GLM::IRLS::Base
        def initialize data_set, dependent, opts={}
          super data_set, dependent, opts
        end

        def to_s
          "Statsample::GLM::Logistic"
        end

       protected

        def measurement x, b
          (x * b).map { |y| 1/(1 + Math.exp(-y)) }
        end

        def weight x, b
          mus = measurement(x,b).column_vectors.map(&:to_a).flatten
          mus_intermediate = mus.map { |p| 1 - p }
          weights = mus.zip(mus_intermediate).collect { |x| x.inject(:*) }

          w_mat = Matrix.I(weights.size)
          w_enum = weights.to_enum
          return w_mat.map do |x|
            x.eql?(1) ? w_enum.next : x # diagonal consists of first derivatives of logit
          end
        end

        def jacobian x, b, y
          mu_flat     = measurement(x,b).column_vectors.map(&:to_a).flatten
          column_data = y.zip(mu_flat).map { |x| x.inject(:-) }

          x.transpose * Matrix.column_vector(column_data)
        end

        def hessian x, b
          (x.transpose * weight(x, b) * x).map { |x| -x }
        end
      end
    end
  end
end