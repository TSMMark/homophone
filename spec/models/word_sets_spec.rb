require 'spec_helper'

describe WordSet do
  describe ".from_slug" do
    let(:word_set) { WordSet.create }

    before do
      (0..5).map do |i|
        apply_to = i == 2 ? word_set : WordSet.create

        Slug.create.tap do |slug|
          slug.value = "wha-wha-#{i}"
          slug.word_set_id = apply_to.id
          apply_to.slugs << slug
        end
      end
    end

    it "finds the correct word_set and eager loads it" do
      found = WordSet.from_slug(word_set.to_slug)
      expect(found).to eq(word_set)
    end
  end
end
