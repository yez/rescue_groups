module RescueGroups
  class PictureField
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
      urlSecureThumbnail:   :url_thumbnail,
      urlInsecureFullsize:  :insecure_url_full,
      urlInsecureThumbnail: :insecure_url_thumb,
      original:             :original,
      large:                :large,
      small:                :small
    }.freeze

    # method: all
    # purpose: Return the values of FIELDS for easy use in
    #            requesting fields from the remote API
    # param: none
    # return: <Array[Symbol]> - All defined field names
    def self.all
      FIELDS.values
    end
  end
end
