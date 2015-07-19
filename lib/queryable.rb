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

      # method: where
      # purpose: find one or many objects by any supported filters
      # param: conditions - <Hash> - mutliple keyed hash containing
      #          the conditions to search against.
      #        example: { breed: 'daschund' }
      # return: <Array> -An array of found objects
      #         If the response was not successful, an exception is thrown
      def where(conditions)
        return find(conditions[:id]) if conditions.keys == [:id]

        search_engine = conditions_to_search_engine(conditions)

        response = api_client.post_and_respond(where_body(search_engine))

        fail("Problem with request #{ response.error }") unless response.success?

        return [] if response['data'].nil? || response['data'].empty?

        results_count = response['data'].keys.length

        response['data'].merge(additional_request_data(response, search_engine))

        response['data'].map do |_data_id, data|
          new(data)
        end
      end

      private

      # method: find_body
      # purpose: Return a hash of the queryable's object specific where criteria
      #            to be used in a find call on RescueGroups remote
      # param: ids <Array> - list of primary keys to find remote objects by
      # return: <Hash> - hash containing a specific configuration for performing a
      #           a find call on RescueGroups
      def find_body(ids)
        {
          objectAction: :publicView,
          objectType:   object_type,
          fields:       object_fields.all,
          values:       ids.map { |i| { object_fields::FIELDS[:id] => i } }
        }
      end

      # method: conditions_to_search_engine
      # purpose: Given a list of unmapped filters, call helper method
      #            key_to_rescue_groups_key and add the result to the search
      #            new search engine that is returned
      # param: conditions <Hash> - conditions to conduct the search on
      # return: <Object> -  instantiated search engine
      #           with filters added
      def conditions_to_search_engine(conditions)
        search_engine = search_engine_class.new

        key_to_rescue_groups_key(conditions) do |mapped_key, val|
          equality_operator = :equal

          if val.is_a?(Hash)
            equality_operator = val.keys[0]
            val = val.values[0]
          end

          search_engine.add_filter(mapped_key, equality_operator, val)
        end

        search_engine
      end

      # method: where_body
      # purpose: Return a hash of the queryable's object specific where criteria
      #            to be used in a search call on RescueGroups remote
      # param: search_engine - <Object> - instantiated search engine
      # return: <Hash> - hash containing a specific configuration for performing a
      #           a search on RescueGroups
      def where_body(search_engine)
        {
          objectAction: :publicSearch,
          objectType:   object_type,
          search:       search_engine.as_json,
        }
      end

      # method: additional_request_data
      # purpose: Alter the limit of a passed in search engine passed on an initial response
      #            of a where request. The limit is increased by 1x per the difference of how
      #            many results were found in the search and how many were returned.
      # param: response - <Object> - Initial response from a where call with the count of
      #         found rows and returned values
      # param: search_engine - <Object> - Search engine with all added fitlers used in the
      #          original where call
      # return: <Hash> - Additional search results for the same filters
      def additional_request_data(response, search_engine)
        return {} if hit_request_limit?(response)

        {}.tap do |data|
          (response['found_rows'] / search_engine.limit).times.each do |i|
            search_engine.start = search_engine.limit * (i + 1)

            additional_results_response = api_client.post_and_respond(where_body(search_engine))
            if !additional_results_response.success?
              fail("Problem with request #{ additional_results_response.error }")
            end

            data.merge(additional_results_response['data'])
          end
        end
      end

      # method: hit_request_limit?
      # purpose: Determine if the response has more data inline than the found_rows
      # param: response - <Object> - Response from RescueGroups
      # return: <Boolean>
      def hit_request_limit?(response)
        return true unless !response.nil? && !response['data'].nil? && !response['data'].empty?
        response['found_rows'].nil? || response['data'].keys.length >= response['found_rows']
      end

      # method: key_to_rescue_groups_key
      # purpose: map conditional arguments given to
      #          their corresponding filters
      # example: key_to_rescue_groups_key(eye_color: 'brown')
      #          #=> Filter.new(name: 'animalEyeColor', operation: 'equal', criteria: 'brown')
      # params: conditions - <Hash> - conditions passed from .where
      #         block - <Block> - evaluated block with the mapped key and value
      def key_to_rescue_groups_key(conditions, &block)
        fail('Block not given') unless block_given?
        conditions.each do |key, value|
          mapped_key = object_fields::FIELDS[key.to_sym]

          next if mapped_key.nil?

          yield mapped_key, value
        end
      end
    end
  end
end
