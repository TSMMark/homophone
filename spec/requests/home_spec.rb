require "spec_helper.rb"

describe "/" do
  describe "when the db is empty" do
    it "renders" do
      get "/"
      expect(response).to render_template("pages/home")
      expect(response.body).to include("Please add some homophones")
    end
  end
end
