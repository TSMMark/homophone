json.array!(@word_sets) do |word_set|
  json.extract! word_set, :id, :visits
  json.url word_set_url(word_set, format: :json)
end
