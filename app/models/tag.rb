class Tag < ActiveRecord::Base
  belongs_to :uploader, class_name: "User"
  belongs_to :taggable, polymorphic: true

  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  def image?
    image_file_name.present?
  end

  def to_geojson
    tag = {}
    tag["type"] = "Feature"
    tag["id"] = id
    tag["geometry"] = RGeo::GeoJSON.encode(coordinates)
    properties = {}
    properties["comments"] = comments
    properties["uploader"] = user.username unless user.nil?
    properties["image_path"] = image_path
    tag["properties"] = properties
    tag
  end

  def image_path
    Rails.root.join('lib', 'geojson', image_file_name)
  end
end
