json.array!(@trees) do |tree|
  json.extract! tree, :id, :name, :description, :stock
  json.url tree_url(tree, format: :json)
end
