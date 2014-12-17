require 'spec_helper'

describe "short word_set path" do

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

describe "vanity word_set path" do
  context "when words have weird characters" do
    [
      [%w(h3l1uM SKY-net 48295), "h3l1um-sky-net-48295", true],
      [%w(its' it's its), "its-it-s-its", true],
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
          it "generates the slug: #{expected_slug.inspect}" do
            expect(word_set.to_slug).to eq(expected_slug)
          end
        end

        it "#{expected_route ? "routes" : "does not route"}" do
          expect(:get => "/h/#{word_set.to_slug}").to route_to(
            :controller => "word_sets",
            :action => "from_slug",
            :slug => word_set.to_slug
          )
        end
      end
    end
  end
end
