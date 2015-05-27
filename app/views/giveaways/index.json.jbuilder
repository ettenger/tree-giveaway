json.array!(@giveaways) do |giveaway|
  json.extract! giveaway, :id, :name, :description, :location, :time
  json.url giveaway_url(giveaway, format: :json)
end
