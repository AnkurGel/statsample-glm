module Statsample

  module GLM
    module MLE
      class Base
          attr_reader :coefficients, :iterations, 
            :fitted_mean_values, :residuals, :degree_of_freedom,
            :log_likelihood
  
        MIN_DIFF_PARAMETERS=1e-2

        def initialize data_set, dependent, opts
          @opts = opts

          @data_set  = data_set
          @dependent = dependent

          @stop_criteria  = :parameters
          @var_cov_matrix = nil
          @iterations     = nil
          @parameters     = nil

          x = @data_set.to_matrix
          y = @dependent.to_matrix(:vertical)

          @coefficients   = newton_raphson x, y
          @log_likelihood = _log_likelihood x, y, @coefficients
          @fitted_mean_values = create_vector measurement(x, @coefficients).to_a.flatten
          @residuals = @dependent - @fitted_mean_values
          @degree_of_freedom  = @dependent.count - x.column_size

          # This jugad is done because the last vector index for Normal is sigma^2
          # which we dont want to return to the user.
          @coefficients =  create_vector(self.is_a?(Statsample::GLM::MLE::Normal) ? 
            @coefficients.to_a.flatten[0..-2] : @coefficients.to_a.flatten)
        end

        def standard_error
          out = []

          @data_set.fields.each_index do |i|
            out << Math::sqrt(@var_cov_matrix[i,i])
          end

          out
        end

        # Newton Raphson with automatic stopping criteria.
        # Based on: Von Tessin, P. (2005). Maximum Likelihood Estimation With Java and Ruby
        #
        # <tt>x</tt>:: matrix of dependent variables. Should have nxk dimensions
        # <tt>y</tt>:: matrix of independent values. Should have nx1 dimensions
        # <tt>@m</tt>:: class for @ming. Could be Normal or Logistic
        # <tt>start_values</tt>:: matrix of coefficients. Should have 1xk dimensions
        def newton_raphson(x,y, start_values=nil)
          # deep copy?
          if start_values.nil?
              parameters = set_default_parameters(x)
          else
              parameters = start_values.dup
          end
          k = parameters.row_size

          raise "n on y != n on x" if x.row_size != y.row_size
          h  = nil
          fd = nil

          if @stop_criteria == :mle
            old_likelihood = _log_likelihood(x, y, parameters)
          else
            old_parameters = parameters
          end
        
          @opts[:iterations].times do |i|
            @iterations = i + 1

            h = second_derivative(x,y,parameters)
            if h.singular?
              raise "Hessian is singular!"
            end
            fd = first_derivative(x,y,parameters)
            parameters = parameters - (h.inverse * (fd))
            
            if @stop_criteria == :parameters
              flag = true
              k.times do |j|
                diff = ( parameters[j,0] - old_parameters[j,0] ) / parameters[j,0]
                flag = false if diff.abs >= MIN_DIFF_PARAMETERS

              end
              
              if flag
                @var_cov_matrix = h.inverse*-1.0
                return parameters
              end
              old_parameters = parameters
            else
              begin
                new_likelihood = _log_likelihood(x,y,parameters)

                if(new_likelihood < old_likelihood) or ((new_likelihood - old_likelihood) / new_likelihood).abs < @opts[:epsilon]
                  @var_cov_matrix = h.inverse*-1.0
                  break;
                end
                old_likelihood = new_likelihood
              rescue =>e
                puts "#{e}"
              end
            end
          end
          @parameters = parameters
          parameters
        end

       private
        # Calculate likelihood for matrices x and y, given b parameters
        def likelihood x,y,b
          prod = 1
          x.row_size.times{|i|
            xi=Matrix.rows([x.row(i).to_a.collect{|v| v.to_f}])
            y_val=y[i,0].to_f
            #fbx=f(b,x)
            prod=prod*likelihood_i(xi, y_val ,b)
          }
          prod
        end

        # Calculate log likelihood for matrices x and y, given b parameters
        def _log_likelihood x,y,b 
          sum = 0
          x.row_size.times{|i|
            xi = Matrix.rows([x.row(i).to_a.collect{|v| v.to_f}])
            y_val = y[i,0].to_f
            sum += log_likelihood_i xi, y_val, b
          }

          sum
        end
        
        # Creates a zero matrix Mx1, with M=x.M
        def set_default_parameters x
          fd = [0.0] * x.column_size

          fd.push(0.1) if self.is_a? Statsample::GLM::MLE::Normal
          Matrix.columns([fd])
        end

        def create_vector arr
          Statsample::Vector.new(arr, :scale)
        end
      end
    end
  end
end
require 'statsample/mle/normal'
require 'statsample/mle/logit'
require 'statsample/mle/probit'
