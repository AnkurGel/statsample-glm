require 'statsample-glm/glm/irls/base'

module Statsample
  module GLM
    module IRLS
      class Poisson < Statsample::GLM::IRLS::Base
        def initialize data_set, dependent, opts={}
          super data_set, dependent, opts
        end

        def to_s
          puts "Logistic Regression (Statsample::Regression::GLM::Logistic)"
        end
       protected

        def measurement x, b
          if @opts[:link] == :log
            (x * b).map { |y| Math.exp(y) }
          elsif @opts[:link] == :sqrt
            (x * b).map { |y| y**2 }
          end
        end

        def weight x, b
          m = measurement(x,b).column_vectors.map(&:to_a).flatten

          w_mat  = Matrix.I(m.size)
          w_enum = m.to_enum

          return w_mat.map do |x|
            x.eql?(1) ? w_enum.next : x # diagonal consists of first derivatives of logit
          end
        end

        def hessian x, b
          (x.transpose * weight(x, b) * x).map { |x| -x }
        end

        def jacobian x, b, y
          measurement_flat = measurement(x,b).column_vectors.map(&:to_a).flatten
          column_data = y.zip(measurement_flat).collect { |x| x.inject(:-) }

          x.transpose * Matrix.columns([column_data])
        end
      end
    end
  end
end