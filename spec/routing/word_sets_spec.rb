require 'spec_helper'

describe "short word_set url" do

  let(:word_set) do
    WordSet.create do |word_set|
      word_set.words = %w(wh wha what)
    end
  end

  it "helper uses correct path" do
    expect(word_set_path(word_set)).to eq("/h/#{word_set.id}")
  end

  it "routes to show" do
    expect(:get => "/h/#{word_set.id}").to route_to(
      :controller => "word_sets",
      :action => "show",
      :id => word_set.id.to_s
    )
  end

end
