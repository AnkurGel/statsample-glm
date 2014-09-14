module Statsample
  module GLM
    module IRLS
      class Base

        attr_reader :coefficients, :standard_error, :iterations, 
          :fitted_mean_values, :residuals, :degree_of_freedom

        def initialize data_set, dependent, opts={}
          @data_set  = data_set.to_matrix
          @dependent = dependent
          @opts      = opts

          irls
        end

       private

        def irls

          max_iter   = @opts[:iterations]
          b          = Matrix.column_vector Array.new(@data_set.column_size,0.0)

          1.upto(max_iter) do
            intermediate = (hessian(@data_set,b).inverse * 
                            jacobian(@data_set, b, @dependent))

            b_new        = b - intermediate

            if((b_new - b).map(&:abs)).to_a.flatten.inject(:+) < @opts[:epsilon]
              b = b_new
              break
            end
            b = b_new
          end

          @coefficients       = create_vector(b.column_vectors[0])
          @iterations         = max_iter
          @standard_error     = hessian(@data_set,b).inverse
                                                    .diagonal
                                                    .map{ |x| -x}
                                                    .map{ |y| Math.sqrt(y) }
          @fitted_mean_values = create_vector measurement(@data_set,b).to_a.flatten
          @residuals          = @dependent - @fitted_mean_values
          @degree_of_freedom  = @dependent.count - @data_set.column_size
        end

        def create_vector arr
          Statsample::Vector.new(arr, :scale)
        end
      end
    end
  end
end