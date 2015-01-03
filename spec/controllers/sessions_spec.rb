require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "works when there is no referer" do
      get :new
      expect(response).to render_template("sessions/new")
    end
  end

  describe "POST create" do
    let(:email) { "user@example.com" }
    let(:password) { "whatever123" }

    let(:params) { {
      :email => email,
      :password => password
    } }
    let(:user) { User.create(params) }

    before do
      user
      post(:create, params)
    end

    context "when session[:return_to] is nil" do
      it "redirects to root_path" do
        assert_response_redirect(response, root_path)
      end
    end

    context "when session[:return_to] is a URI" do
      it "redirects to session[:return_to]" do
        skip "TODO"
      end
    end
  end

end
