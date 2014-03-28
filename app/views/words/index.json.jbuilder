json.array!(@words) do |word|
  json.extract! word, :id, :text, :visits
  json.url word_url(word, format: :json)
end
