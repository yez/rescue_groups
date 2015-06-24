module RescueGroups
  module Queryable
    # This method is called when the Queryable Module is included
    #   in a class.
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # method: find
      # purpose: find one or many objects by primary key (id)
      # param: ids Array<Integer> primary key(s) of object(s) that will
      #          be requested
      # return: One found object if one id was given, otherwise an array of found objects
      #         If the response was not successful, an exception is thrown
      def find(ids)
        ids_array = [*ids].flatten

        find_body = {
          objectAction: :publicView,
          objectType:   object_type,
          fields:       object_fields.all,
          values:       ids_array.map { |i| { object_fields::FIELDS[:id] => i } }
        }

        response = api_client.post_and_respond(find_body)

        unless response.success? && !response['data'].nil? && !response['data'].empty?
          fail "Unable to find #{ self.name } with id: #{ ids }"
        end

        objects = response['data'].map { |data| new(data) }

        ids_array.length == 1 ? objects.first : objects
      end

      # method: where
      # purpose: find one or many objects by any supported filters
      # param: conditions - <Hash> - mutliple keyed hash containing
      #          the conditions to search against.
      #        example: { breed: 'daschund' }
      # return: An array of found objects
      #         If the response was not successful, an exception is thrown
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

        fail("Problem with request #{ response.error }") unless response.success?

        response['data'].map do |_data_id, data|
          new(data)
        end
      end

      private
      # method: conditions_to_filters
      # purpose: map conditional arguments given to
      #          their corresponding filters
      # example: conditions_to_filters(eye_color: 'brown')
      #          #=> Filter.new(name: 'animalEyeColor', operation: 'equal', criteria: 'brown')
      # params: conditions - <Hash> - conditions passed from .where
      #         block - <Block> - evaluated block with the mapped key and value
      def conditions_to_filters(conditions, &block)
        fail('Block not given') unless block_given?
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
