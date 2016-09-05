require 'sequel'

def modify(ns, column_config, value)
  features = JSON.parse(value)['features'].compact
  return nil unless features.length > 0

  collection = features.map{|feature|
    Sequel::SQL::Function.new(
        'ST_AsText',
        Sequel::SQL::Function.new('ST_GeomFromGeoJSON', JSON.dump(feature['geometry']))
    )
  }
  Sequel::SQL::Function.new('CONCAT', 'GEOMETRYCOLLECTION(', *collection, ')')
end