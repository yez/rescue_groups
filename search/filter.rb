class Filter
  attr_accessor :name, :operation, :criteria

  OPERATIONS = %i[equal notequal
                  lessthan lessthanorequal
                  greaterthan greaterthanorequal
                  contains notcontain
                  blank notblank
                  radius].freeze

  def initialize(name, operation, criteria)
    @name      = name
    @operation = OPERATIONS.find { |o| o == operation.to_sym }
    @criteria  = criteria
  end

  def as_json(*args)
    {
      fieldName: name,
      operation: operation,
      criteria: criteria
    }
  end
end
