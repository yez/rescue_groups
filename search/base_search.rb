require_relative './filter'

module RescueGroups
  class BaseSearch
    attr_accessor :start, :limit, :sort, :order,
                  :calc_found_rows, :fields, :filters

    # method: fields
    # purpose: Base definition of fields methods, all inherited classes
    #            for specialized search should define their own version of fields
    # param: none
    # return: <Exception> - raises an exception if this definition of fields is called
    def self.fields
      raise 'Fields called on base class'
    end

    # method: initialize
    # purpose: Set important instance variables for any new instance of this class
    # params: start <integer> - Offset to conduct the search against
    #         limit <integer> - Number of search results to return
    #         sort <Symbol>   - Field to sort the results over
    #         order <Symbol>  - Results returned in ascending or descending order
    # return:
    def initialize(start = 0, limit = 100, sort = nil, order = :asc)
      @start           = start
      @limit           = limit
      @sort            = sort
      @order           = order
      @calc_found_rows = 'Yes'
      @fields          = self.class.fields
      @filters         = []
    end

    # method: add_filter
    # purpose: Instantiate and add a new filter to the search classes array of filters
    # param: name <String>      - Name of the filter (in RescueGroups' mapping) to filter results on
    #        assertion <Symbol> - Type of equivalency to check against
    #                             Supported values: [:equal, :notequal, :lessthan, :lessthanorequal,
    #                                                :greaterthan, :greaterthanorequal, :contains,
    #                                                :blank, :notblank]
    #        equals <String>    - Value to run the type of equivalency check against
    # return: none
    def add_filter(name, assertion, equals)
      @filters << Filter.new(name, assertion, equals)
    end

    # method: as_json
    # purpose: Convert instance variables into a hash used to make the search POST
    #            to the RescueGroups API
    # param: none
    # return: <Hash> - keyed values of local variables
    def as_json
      {
        resultStart:   start,
        resultLimit:   limit,
        resultSort:    sort,
        resultOrder:   order,
        calcFoundRows: calc_found_rows,
        filters:       filters.map(&:as_json),
        fields:        fields
      }
    end

    # method: to_json
    # purpose: JSON encode the result of as_json
    # param: none
    # return: <String> - JSON encoded string
    def to_json
      JSON(as_json)
    end
  end
end
