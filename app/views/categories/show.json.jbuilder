json.extract! @category, :id, :name, :parent_id
json.subcategories @category.subcategories
