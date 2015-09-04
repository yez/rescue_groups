require_relative './requests/find'
require_relative './requests/where'

module RescueGroups
  class NotFound < StandardError; end
  class InvalidRequest < StandardError; end

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
          fail(NotFound, "Unable to find #{ self.name } with id: #{ ids }")
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

        fail(InvalidRequest, "Problem with request #{ response.error }") unless response.success?

        response_with_additional = additional_request_data(where_request)

        response_with_additional['data'].map do |_data_id, data|
          new(data)
        end
      end

      private

      def additional_request_data(request)
        unless RescueGroups.config.load_all_results && request.can_request_more?
          return request.results
        end

        (request.results['found_rows'] / request.search_engine.limit).times.each do |i|
          request.update_conditions!(limit: request.search_engine.limit * (i + 1))

          additional_results_response = request.request
          if !additional_results_response.success?
            fail(InvalidRequest, "Problem with request #{ additional_results_response.error }")
          end
        end

        request.results
      end
    end
  end
end
