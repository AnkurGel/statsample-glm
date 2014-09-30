describe Statsample::GLM::Probit do
  context "IRLS algorithm" do
    # TODO : Implement this!
  end

  context "MLE algorithm" do
    before do
      @data_set = Statsample::CSV.read 'spec/data/logistic_mle.csv'
      @glm      = Statsample::GLM.compute @data_set, :y, :probit, 
                    {algorithm: :mle, constant: 1}
    end

    it "reports correct values as an array" do
      expect_similar_vector(@glm.coefficients,[0.1763,0.4483,-0.2240,-3.0670],0.001)

      expect(@glm.log_likelihood).to be_within(0.0001).of(-38.31559)
    end
  end
end