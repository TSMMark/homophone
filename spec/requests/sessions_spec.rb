require "spec_helper.rb"

describe "/sessions/new" do
  it "works when there is no referer" do
    get "/sessions/new"
    expect(response).to render_template("sessions/new")
  end
end
