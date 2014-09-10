json.array!(@sentences) do |sentence|
  json.extract! sentence, :id, :content
  json.url sentence_url(sentence, format: :json)
end
