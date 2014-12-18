require "spec_helper"

describe "sitemap:generate" do
  before do
    skip "TODO: This does not work because our shared context only loads for our own rake tasks."
  end

  include_context "rake"

  describe "when there are word_sets" do
    let(:word_set) do
      WordSet.create
    end

    let(:slug) { Slug.create({
      :word_set_id => word_set.id,
      :value => "wha-wha-wha"
    }) }

    before { word_set.slugs << slug }

    it "adds a node for the word_set" do
      subject.invoke

      # expect that file exists
      # cleanup the file
    end
  end
end
