require 'spec_helper'

describe "short word_set path" do

  let(:word_set) do
    WordSet.create do |word_set|
      word_set.words = %w(wh wha what)
    end
  end

  it "default path helper uses #id" do
    expect(word_set_path(word_set)).to eq("/h/#{word_set.id}")
  end

  it "routes to show" do
    expect(:get => "/h/#{word_set.id}").to route_to(
      :controller => "word_sets",
      :action => "show",
      :id => word_set.id.to_s
    )
  end


  describe "slug path helper" do
    context "when word_set has a slug" do
      before do
        Slug.create_for_word_set(word_set)
      end

      it "uses #to_slug" do
        expect(word_set.slug).not_to be_nil
        expect(word_set_slug_path(word_set.to_slug)).to eq("/h/#{word_set.to_slug}")
      end
    end

    context "when word_set has no slug" do
      it "uses #id" do
        expect(word_set.slug).to be_nil
        expect(word_set_slug_path(word_set.to_slug)).to eq("/h/#{word_set.id}")
      end
    end
  end
end

describe "vanity word_set path" do
  context "when words have weird characters" do
    [
      [%w(h3l1uM SKY-net 48295), "48295-h3l1um-sky-net", true],
      [%w(its' it's its), "it-s-its-its", true],
      [%w(porter+robinson porter(robinson)), "porter-robinson-porter-robinson", true]
    ].each do |words, expected_slug, expected_route|
      context "when words are #{words.map(&:inspect).join(", ")}" do
        let(:word_set) do
          WordSet.create.tap do |word_set|
            word_set.words = words
          end
        end

        let(:slug) do
          Slug.create_for_word_set(word_set)
        end

        before do
          slug
        end

        describe "#to_slug" do
          it "sorts the elements and generates the slug: #{expected_slug.inspect}" do
            expect(word_set.to_slug).to eq(expected_slug)
          end
        end

        it "#{expected_route ? "routes" : "does not route"}" do
          expect(:get => word_set_slug_path(word_set.to_slug)).to route_to(
            :controller => "word_sets",
            :action => "from_slug",
            :slug => word_set.to_slug
          )
        end
      end
    end
  end
end
