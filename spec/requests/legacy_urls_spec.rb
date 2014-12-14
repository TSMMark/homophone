require "spec_helper"

describe "legacy routes" do

  %w[
    index.php
    adsense.html
    mobile.php
    bubbagump.php
  ].each do |path|
    path = "/#{path}"
    describe "when path is #{path.inspect}" do
      it "redirects to root" do
        get path
        assert_response_redirect(response, root_path)
      end
    end
  end

  describe "/results.php" do
    [
      %w[begin O],
      %w[include Z],
      %w[include th],
      %w[begin ari]
    ].each do |(type, q)|
      describe "when type=#{type} & q=#{q}" do
        it "redirects and keeps the arguments" do
          get "/results.php?how=#{type}&searchfor=#{q}"
          assert_response_redirect(response, "/search?type=#{type}&q=#{q}")
        end
      end
    end
  end

end
