namespace :db do
  namespace :slugs do

    desc "Create slugs for all word_sets that don't have a slug"
    task :create => :environment do
      dupes = [["conflicting id", "existing id", "slug value"]]

      ref = Slug.select(:word_set_id)
      WordSet.where("word_sets.id NOT IN (?)", ref).find_each do |word_set|
        begin
          Slug.create_for_word_set(word_set)
        rescue ActiveRecord::RecordNotUnique => e
          value = Slug.value_for_word_set(word_set)
          dupes << [word_set.id, WordSet.from_slug(value).id, value]
        end
      end

      puts "DUPLICATES:", dupes.map{ |a| a.join(", ") }.join("\n")
    end
  end
end
