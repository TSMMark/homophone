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

describe "/random" do
  describe "when the db is empty" do
    it "redirects to root" do
      get "/random"
      expect(response).to redirect_to(root_path)
    end
  end
end
