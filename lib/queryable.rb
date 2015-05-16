module RescueGroups
  module Queryable
    def self.included(base)
      base.class_eval do
        class << self
          def find(ids)
            ids_array = [*ids].flatten

            find_body = {
              objectAction: :publicView,
              objectType:   object_type,
              fields:       object_fields.all,
              values:       ids_array.map { |i| { object_fields::FIELDS[:id] => i } }
            }

            response = api_client.post_and_respond(find_body)

            fail "Unable to find #{ self.name } with id: #{ ids }" unless response.success?

            objects = response['data'].map { |data| new(data) }

            ids_array.length == 1 ? objects.first : objects
          end

          def where(conditions)
            return find(conditions[:id]) if conditions.keys == [:id]

            search_engine = search_engine_class.new

            conditions_to_filters(conditions) do |mapped_key, val|
              search_engine.add_filter(mapped_key, :equal, val)
            end

            where_body = {
              objectAction: :publicSearch,
              objectType:   object_type,
              search:       search_engine.as_json,
            }

            response = api_client.post_and_respond(where_body)

            return [] unless response.success?

            response['data'].map do |_data_id, data|
              new(data)
            end
          end

          def conditions_to_filters(conditions, &block)
            conditions.each do |key, value|
              mapped_key = object_fields::FIELDS[key.to_sym]
              next if mapped_key.nil?

              [*value].flatten.each do |val|
                yield mapped_key, val
              end
            end
          end
        end
      end
    end
  end
end
