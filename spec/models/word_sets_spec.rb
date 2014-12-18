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

  describe "#to_slug" do
    let(:word_set) { WordSet.create }
    let(:slugs) do
      (0..5).map do |i|
        Slug.create do |slug|
          slug.word_set_id = word_set
          slug.value = "wha-wha-#{i}"
          slug.created_at = Time.now.utc - (i * 5)
          word_set.slugs << slug
        end
      end
    end

    describe "when the word_set has multiple slugs" do
      before do
        @last_created_at_slug = slugs.first
      end

      it "uses the last created_at slug" do
        expect(word_set.to_slug).to eq(@last_created_at_slug.value)
      end
    end

    describe "when the word_set has no slugs" do
      it "uses the word_set.id" do
        expect(word_set.to_slug).to eq(word_set.id.to_s)
      end
    end
  end
end
