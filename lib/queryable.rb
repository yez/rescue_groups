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
        response = api_client.post_and_respond(find_body(ids_array))

        unless response.success? && !response['data'].nil? && !response['data'].empty?
          fail "Unable to find #{ self.name } with id: #{ ids }"
        end

        objects = response['data'].map { |data| new(data) }

        ids_array.length == 1 ? objects.first : objects
      end

      def find_body(ids)
        {
          objectAction: :publicView,
          objectType:   object_type,
          fields:       object_fields.all,
          values:       ids.map { |i| { object_fields::FIELDS[:id] => i } }
        }
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

        search_engine = conditions_to_search_engine(conditions)

        response = api_client.post_and_respond(where_body(search_engine))

        fail("Problem with request #{ response.error }") unless response.success?

        return [] if response['data'].nil? || response['data'].empty?

        results_count = response['data'].keys.length

        if response['found_rows'] && results_count < response['found_rows']
          (response['found_rows'] / search_engine.limit).times.each do |i|
            search_engine.start = search_engine.limit * (i + 1)
            additional_results_response = api_client.post_and_respond(where_body(search_engine))
            fail("Problem with request #{ additional_results_response.error }") unless additional_results_response.success?
            response['data'].merge(additional_results_response['data'])
          end
        end

        response['data'].map do |_data_id, data|
          new(data)
        end
      end

      def conditions_to_search_engine(conditions)
        search_engine = search_engine_class.new

        conditions_to_filters(conditions) do |mapped_key, val|
          search_engine.add_filter(mapped_key, :equal, val)
        end

        search_engine
      end


      def where_body(search_engine)
        {
          objectAction: :publicSearch,
          objectType:   object_type,
          search:       search_engine.as_json,
        }
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
