require 'spec_helper'

describe WordSetsController do
  describe "GET from_slug" do
    context "when a word_set has multiple slugs" do
      let(:word_set) { WordSet.create }
      let(:slugs) do
        (0..5).map do |i|
          Slug.create.tap do |slug|
            slug.value = "wha-wha-#{i}"
            slug.word_set_id = word_set.id
            word_set.slugs << slug
          end
        end
      end

      it "is able to route using any of the slugs" do
        slugs.map(&:value).each do |slug_value|
          get(:from_slug, {
            :slug => slug_value
          })
          expect(response).to render_template("show")
        end
      end
    end
  end

  describe "POST create" do
    let(:words) { %w[wha ska fla] }

    let(:params) { { :word_set => {
      :words => words.map { |t| { :text => t } }
    } } }

    before do
      admin!
      post(:create, params)
      @last_word_set = WordSet.last
    end

    it "creates a word_set with 3 words" do
      expect(@last_word_set.words.count).to eq(3)
    end

    it "creates an appropriate slug for the word_set" do
      expect(@last_word_set.slugs.count).to eq(1)
      expect(@last_word_set.slug).not_to be_nil
      expect(@last_word_set.to_slug).to eq(words.join("-"))
      expect(@last_word_set.slug.value).to eq(@last_word_set.to_slug)
    end

    it "redirects to the #show path for the word_set" do
      assert_response_redirect(response, "/h/#{@last_word_set.id}")
    end
  end
end
