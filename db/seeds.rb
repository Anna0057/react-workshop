# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

do_log = -> (s) {
  Rails.logger.info s
  puts s
}

# Локации
locations_csv = File.join __dir__, 'seeds/locations.csv'
locations_old_count = 0
locations_new_count = 0

CSV.foreach(locations_csv, headers: true, header_converters: :symbol) do |row|
  location = Location.find_or_initialize_by id: row[:id]
  locations_old_count += 1 and next if location.persisted?
  location.update_attributes name: row[:name],
                             parent_id: row[:parent_id]
  locations_new_count += 1
end

do_log.(format('Локации загружены. старых: %d , новых: %d', locations_old_count, locations_new_count))

# Категории
categories_csv = File.join __dir__, 'seeds/categories.txt'
categories_old_count = 0
categories_new_count = 0
parent = nil

File.foreach(categories_csv) do |row|
  next if row.strip == ''
  parent = nil if row.match /^\S/
  params = { parent_id: parent && parent.id, name: row.strip }
  category = Category.find_or_initialize_by params
  categories_old_count += 1 and next if category.persisted?
  category.save!
  parent = category if row.match /^\S/
  categories_new_count += 1
end

do_log.(format('Категории загружены. старых: %d , новых: %d', categories_old_count, categories_new_count))
