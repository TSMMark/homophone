require 'spec_helper'

describe WordSetsController do
  describe "GET show" do
    context "when a word_set no slugs" do
      let(:word_set) { WordSet.create }

      it "renders #show" do
        get(:show, {
          :id => word_set.id
        })
        expect(response).to render_template("show")
      end
    end

    context "when a word_set at least 1 slug" do
      let(:word_set) { WordSet.create }
      let(:slug) do
        Slug.create.tap do |slug|
          slug.value = "wha-wha-wha"
          slug.word_set_id = word_set.id
          word_set.slugs << slug
        end
      end

      it "redirects to #from_slug" do
        slug_value = slug.value

        get(:show, {
          :id => word_set.id
        })
        assert_response_redirect(response, "/h/#{slug_value}")
      end
    end
  end

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
    let(:words) { %w[fla ska wha] }

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

  describe "PUT update" do
    let(:word_set) do
      WordSet.create.tap do |word_set|
        word_set.words = old_words
        word_set.save!
      end
    end

    let(:old_words) { %w[fla ska wha] }

    let(:params) { { :id => word_set.id, :word_set => {
      :words => new_words.map { |t| { :text => t } }
    } } }

    before do
      @slug = Slug.create_for_word_set(word_set)
      admin!
    end

    describe "when the words haven't changed" do
      let(:new_words) { old_words }

      it "does not create a new slug" do
        expect(Slug.count).to eq(1)
        expect(word_set.to_slug).to eq(old_words.join("-"))

        put(:update, params)

        expect(word_set.to_slug).to eq(old_words.join("-"))
        expect(Slug.count).to eq(1)
      end
    end

    describe "when at least one of the words has changed" do
      let(:new_words) { %w[fla ska who] }

      it "creates a new slug" do
        expect(Slug.count).to eq(1)
        expect(word_set.to_slug).to eq(old_words.join("-"))

        put(:update, params)

        word_set.reload
        expect(word_set.to_slug).to eq(new_words.join("-"))
        expect(Slug.count).to eq(2)
      end
    end
  end
end
