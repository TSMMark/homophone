require 'spec_helper'

describe PagesController do

  context "GET home" do
    before { get :home }

    it { expect(response).to render_template("home") }
  end

end
