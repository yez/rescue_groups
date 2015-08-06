module RescueGroups
  class Filter
    attr_reader :name, :operation, :criteria

    OPERATIONS = {
      equal:                 :equal,
      not_equal:             :notequal,
      less_than:             :lessthan,
      less_than_or_equal:    :lessthanorequal,
      greater_than:          :greaterthan,
      greater_than_or_equal: :greaterthanorequal,
      contains:              :contains,
      not_contain:           :notcontain,
      blank:                 :blank,
      not_blank:             :notblank,
      radius:                :radius
    }.freeze

    # method: initialize
    # purpose: Set important instance variables for a new Filter
    # params: name <String>      - Name of the filter (in RescueGroups' mapping) to filter results on
    #         operation <Symbol> - Type of equivalency to check against
    #                              Supported values: [:equal, :notequal, :lessthan, :lessthanorequal,
    #                                                :greaterthan, :greaterthanorequal, :contains,
    #                                                :blank, :notblank]
    #         equals <String>    - Value to run the type of equivalency check against
    # return: none
    def initialize(name, operation, criteria)
      @name      = name
      @operation = OPERATIONS[operation] or fail 'Invalid operation given'
      @criteria  = criteria
    end

    # method: as_json
    # purpose: Convert instance variables into a hash used to make the search POST
    #            to the RescueGroups API
    # param: none
    # return: <Hash> - keyed values of local variables
    def as_json
      {
        fieldName: name,
        operation: operation,
        criteria:  criteria
      }
    end
  end
end
