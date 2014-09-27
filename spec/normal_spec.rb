describe Statsample::GLM::Normal do
  context "MLE algorithm", focus: true do
    before do
      # Below data set taken from http://dl.dropbox.com/u/10246536/Web/RTutorialSeries/dataset_multipleRegression.csv
      @ds = Statsample::CSV.read "spec/data/normal.csv"
    end

    it "reports correct values as an array" do
      @glm = Statsample::GLM.compute @ds, 'roll', :normal, {algorithm: :mle}
      
      expect_similar_vector @glm.coefficients, [450.12450365911894, 
        0.4064837278023981, 4.27485769721736,-9153.254462671905]
    end
  end
end