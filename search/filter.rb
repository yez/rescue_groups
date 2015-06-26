class Filter
  attr_accessor :name, :operation, :criteria

  OPERATIONS = %i[equal notequal
                  lessthan lessthanorequal
                  greaterthan greaterthanorequal
                  contains notcontain
                  blank notblank
                  radius].freeze

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
    @operation = OPERATIONS.find { |o| o == operation.to_sym } if operation
    @criteria  = criteria
  end

  # method: as_json
  # purpose: Convert instance variables into a hash used to make the search POST
  #            to the RescueGroups API
  # param: none
  # return: <Hash> - keyed values of local variables
  def as_json
    fail('Invalid operation given') unless !operation.nil?
    {
      fieldName: name,
      operation: operation,
      criteria: criteria
    }
  end
end
