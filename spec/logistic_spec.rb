require 'spec_helper.rb'

describe Statsample::GLM::Logistic do
  context "IRLS algorithm" do
    before do
      @data_set = Statsample::CSV.read "spec/data/logistic.csv"
      @glm  = Statsample::GLM.compute @data_set, 'y', :logistic, {constant: 1}
    end

    it "reports correct coefficients as an array" do
      expect_similar_vector(@glm.coefficients,[-0.312493754568903,
        2.28671333346264,0.675603176233325])

    end

    it "reports correct coefficients as a hash" do
      expect_similar_hash(@glm.coefficients(:hash), {:constant => 0.675603176233325,
        :x1 => -0.312493754568903, :x2 => 2.28671333346264})
    end
  end

  context "MLE algorithm" do
    before do
      @data_set = Statsample::CSV.read("spec/data/logistic_mle.csv")
      @glm      = Statsample::GLM.compute @data_set,'y', :logistic, {constant: 1, algorithm: :mle}
    end

    it "reports correct regression values as an array" do
      expect(@glm.log_likelihood).to be_within(0.001).of(-38.8669)

      expect_similar_vector(@glm.coefficients, [0.3270, 0.8147, -0.4031,-5.3658],0.001)
      expect_similar_vector(@glm.standard_error, [0.4390, 0.4270, 0.3819,1.9045],0.001)

      expect(@glm.iterations).to eq(7)
    end
  end
end