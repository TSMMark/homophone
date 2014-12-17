require "spec_helper"

describe "db:slugs:create" do
  include_context "rake"

  describe "when some word_sets have slugs and some don't" do
    let(:word_sets_with_slugs) do
      (0...5).map do |i|
        WordSet.create.tap do |word_set|
          word_set.words = %W[wha#{i} fla#{i} ska#{i}]
          Slug.create_for_word_set(word_set)
        end
      end
    end

    let(:word_sets_without_slugs) do
      (5...10).map do |i|
        WordSet.create.tap do |word_set|
          word_set.words = %W[wha#{i} fla#{i} ska#{i}]
        end
      end
    end

    before do
      word_sets_with_slugs
      word_sets_without_slugs
    end

    it "starts with 10 word_sets and 5 slugs" do
      expect(WordSet.count).to eq(10)
      expect(Slug.count).to eq(5)
    end

    it "creates a new slug for every word_set that didn't have one already" do
      subject.invoke

      expect(Slug.count).to eq(WordSet.count)
      WordSet.find_each do |word_set|
        expect(word_set.slugs.count).to eq(1)
      end
    end
  end

  describe "when there is a conflict in slug names" do
    it "skips and includes a DUPLICATES report at the end" do
      existing = WordSet.create.tap do |word_set|
        word_set.words = %w[wha fla ska]
      end

      conflict = WordSet.create.tap do |word_set|
        word_set.words = %w[wha fla ska]
      end

      expect{ subject.invoke }.not_to raise_error
      expect(Slug.count).to eq(1)
    end
  end
end
