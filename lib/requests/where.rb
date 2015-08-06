require_relative './invalid_client'

module RescueGroups
  module Requests
    class Where
      attr_reader :search_engine, :results

      def initialize(conditions, model, client, search_engine_class)
        modifiers = %i[limit start sort order]

        conditions.each do |key, value|
          if modifiers.include?(key.to_sym)
            instance_variable_set(:"@#{ key }", conditions.delete(key))
          end
        end

        @conditions = conditions
        @model = model
        @client = client
        @search_engine = build_search_engine(search_engine_class)
        @results = { 'data' => {} }
      end

      def request
        raise InvalidClient, 'Invalid client given to Requests::Where' unless @client.respond_to?(:post_and_respond)
        response = @client.post_and_respond(as_json)

        if response.success? && !response['data'].empty?
          @results['found_rows'] = response['found_rows']
          @results['data'].merge!(response['data'])
        end

        response
      end

      def as_json(*)
        {
          objectAction: :publicSearch,
          objectType:   @model.object_type,
          search:       @search_engine.as_json,
        }
      end

      def update_conditions!(conditions)
        @conditions.merge!(conditions)
      end

      def can_request_more?
        return false if results.nil? || results['data'].nil? || results['data'].empty?
        !results['found_rows'].nil? && results['data'].keys.length < results['found_rows']
      end

      private

      def build_search_engine(search_engine_class)
        args = {
          limit: @limit,
          start: @start,
          sort: @sort,
        }.reject { |_, v| v.nil? }

        search = search_engine_class.new(**args)

        add_filters_to_search_engine(search)

        search
      end

      def add_filters_to_search_engine(search)
        conditions_to_rescue_groups_key_value do |mapped_key, val|
          equality_operator = :equal

          if val.is_a?(Hash)
            equality_operator = val.keys[0]
            val = val.values[0]
          end

          search.add_filter(mapped_key, equality_operator, val)
        end
      end

      def conditions_to_rescue_groups_key_value(&block)
        fail('Block not given') unless block_given?
        @conditions.each do |key, value|
          mapped_key = @model.object_fields::FIELDS[key.to_sym]

          next if mapped_key.nil?

          yield mapped_key, value
        end
      end
    end
  end
end
