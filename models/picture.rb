require_relative '../fields/picture_field'

module RescueGroups
  class Picture
    include Relationable

    belongs_to :animal

    attr_accessor *PictureField::FIELDS.values

    def initialize(attribute_hash = {})
      attribute_hash.each do |key, value|
        mapped_key = PictureField::FIELDS[key.to_sym]
        self.send(:"#{ mapped_key }=", value) unless mapped_key.nil?
      end
    end

    def url(secure: false)
      secure ? url_full : insecure_url_full
    end

    def url_thumb(secure: false)
      secure ? url_thumbnail : insecure_url_thumb
    end
  end
end
