require "spec_helper"

describe "sitemap:generate" do
  skip { "Does not work because our shared context only searches for our rake tasks" }

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

      # expect file exists
    end
  end
end
