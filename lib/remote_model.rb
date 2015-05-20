module RescueGroups
  module RemoteModel
    def self.included(base)
      base.class_eval do
        def initialize(attribute_hash)
          attribute_hash.each do |key, value|
            mapped_method = "#{ self.class.object_fields::FIELDS.key(key.to_sym) }="
            next unless self.respond_to?(mapped_method)
            self.send(mapped_method, value)
          end
        end

        def attributes
          {}.tap do |hash|
            self.class.object_fields::FIELDS.keys.each do |attribute|
              hash[attribute] = instance_variable_get(:"@#{ attribute }")
            end
          end
        end
      end
    end
  end
end
