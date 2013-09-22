require 'bio-statsample-glm/regression/poisson'
require 'bio-statsample-glm/regression/logistic'
module Statsample
  module Regression
    include Statsample::VectorShorthands
    def self.glm(x, y, method=:poisson)
      if method.downcase.to_sym == :poisson
        obj = Statsample::Regression::GLM::Poisson.new(x,y)
      elsif method.downcase.to_sym == :binomial
        obj = Statsample::Regression::GLM::Logistic.new(x,y)
      end
      obj
      #now, #irwls method is available to be called on returned obj
    end

    def self.create_vector(arr)
      Statsample::Vector.new(arr, :scale)
    end

    def self.irwls(x, y, mu, w, j, h, epsilon = 1e-7, max_iter = 100)
      b = Matrix.column_vector(Array.new(x.column_size,0.0))
      converged = false
      1.upto(max_iter) do |i|
        #conversion from : (solve(j(x,b)) %*% h(x,b,y))

        intermediate = (j.call(x,b).inverse * h.call(x,b,y))
        b_new = b - intermediate

        if((b_new - b).map(&:abs)).to_a.flatten.inject(:+) < epsilon
          converged = true
          b = b_new
          break
        end
        b = b_new
      end
      ss = j.call(x,b).inverse.diagonal.map{ |x| -x}.map{ |y| Math.sqrt(y) }
      values = mu.call(x,b)

      residuals = y - values.column_vectors.map(&:to_a).flatten
      df_residuals = y.count - x.column_size
      return [create_vector(b.column_vectors[0]), create_vector(ss), create_vector(values.to_a.flatten),
              residuals, max_iter, df_residuals, converged]
    end

  end
end
