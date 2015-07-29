require_relative './requests/find'
require_relative './requests/where'

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
        find_request = Requests::Find.new(ids, self, api_client)

        response = find_request.request

        unless response.success? && !response['data'].nil? && !response['data'].empty?
          fail "Unable to find #{ self.name } with id: #{ ids }"
        end

        objects = response['data'].map { |data| new(data) }

        [*ids].flatten.length == 1 ? objects.first : objects
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

        where_request = Requests::Where.new(conditions, self, api_client, search_engine_class)

        response = where_request.request

        fail("Problem with request #{ response.error }") unless response.success?

        return [] if response['data'].nil? || response['data'].empty?

        results_count = response['data'].keys.length

        response['data'].merge(additional_request_data(response, where_request))

        response['data'].map do |_data_id, data|
          new(data)
        end
      end

      private

      # method: additional_request_data
      # purpose: Alter the limit of a passed in search engine passed on an initial response
      #            of a where request. The limit is increased by 1x per the difference of how
      #            many results were found in the search and how many were returned.
      # param: response - <Object> - Initial response from a where call with the count of
      #         found rows and returned values
      # return: <Hash> - Additional search results for the same filters
      def additional_request_data(response, request)
        return {} if hit_request_limit?(response)

        {}.tap do |data|
          (response['found_rows'] / request.search_engine.limit).times.each do |i|
            request.update_conditions!(limit: request.search_engine.limit * (i + 1))

            additional_results_response = request.request
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
    end
  end
end
