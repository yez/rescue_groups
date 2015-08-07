module RescueGroups
  class Picture
    include Relationable

    belongs_to :animal

    FIELDS = {
      mediaID:              :id,
      mediaOrder:           :order,
      lastUpdated:          :updated_at,
      fileSize:             :file_size,
      resolutionX:          :resolution_x,
      resolutionY:          :resolution_y,
      fileNameFullsize:     :file_name_full_size,
      fileNameThumbnail:    :file_name_thumbnail,
      urlSecureFullsize:    :url_full,
      urlSecureThumbnail:   :url_thumnail,
      urlInsecureFullsize:  :insecure_url_full,
      urlInsecureThumbnail: :insecure_url_thumb,
      original:             :original,
      large:                :large,
      small:                :small
    }

    attr_accessor *FIELDS.values

    def initialize(attribute_hash = {})
      attribute_hash.each do |key, value|
        mapped_key = FIELDS[key.to_sym]
        self.send(:"#{ mapped_key }=", value) unless mapped_key.nil?
      end
    end

    def thumb
      insecure_url_thumb
    end

    def full
      insecure_url_full
    end
  end
end
