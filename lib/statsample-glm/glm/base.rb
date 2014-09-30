require 'statsample-glm/glm/irls/logistic'
require 'statsample-glm/glm/irls/poisson'
require 'statsample-glm/glm/mle/logistic'
require 'statsample-glm/glm/mle/probit'
require 'statsample-glm/glm/mle/normal'

module Statsample
  module GLM
    class Base

      def initialize ds, y, opts={}
        @opts   = opts
          
        set_default_opts_if_any

        @data_set  = ds.dup(ds.fields - [y.to_s])
        @dependent = ds[y.to_s]

        add_constant_vector if @opts[:constant]
        add_constant_vector(1) if self.is_a? Statsample::GLM::Normal

        algorithm = @opts[:algorithm].upcase
        method    = @opts[:method].capitalize

        # TODO: Remove this const_get jugaad after 1.9.3 support is removed.

        @regression = Kernel.const_get("Statsample").const_get("GLM")
                            .const_get("#{algorithm}").const_get("#{method}")
                            .new(@data_set, @dependent, @opts)
      end
      
      def coefficients as_a=:array
        if as_a == :hash
          c = {}
          @data_set.fields.each_with_index do |f,i|
            c[f.to_sym] = @regression.coefficients[i]
          end
          return c
        end
        create_vector @regression.coefficients
      end

      def standard_error as_a=:array  
        if as_a == :hash
          se = {}
          @data_set.fields.each_with_index do |f,i|
            se[f.to_sym] = @regression.standard_error[i]
          end
          return se
        end

        create_vector @regression.standard_error
      end

      def iterations
        @regression.iterations
      end

      def fitted_mean_values
        @regression.fitted_mean_values
      end

      def residuals
        @regression.residuals
      end

      def degree_of_freedom
        @regression.degree_of_freedom
      end

      def log_likelihood
        @regression.log_likelihood if @opts[:algorithm] == :mle
      end

     private

      def set_default_opts_if_any
        @opts[:algorithm]  ||= :irls 
        @opts[:iterations] ||= 100   
        @opts[:epsilon]    ||= 1e-7  
        @opts[:link]       ||= :log  
      end

      def create_vector arr
        Statsample::Vector.new(arr, :scale)
      end

      def add_constant_vector x=nil
        @data_set.add_vector "constant", 
          (([@opts[:constant]]*@data_set.cases).to_vector(:scale))

        unless x.nil?
          @data_set.add_vector "constant", 
            (([1]*@data_set.cases).to_vector(:scale))
        end
      end
    end
  end
end