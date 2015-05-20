require_relative './filter'
require_relative './event_field'

class EventSearch
  attr_accessor :start, :limit, :sort, :order,
                :calc_found_rows, :fields, :filters

  def initialize(start = 0, limit = 10, sort = nil, order = :asc, fields = EventField.all)
    @start           = start
    @limit           = limit
    @sort            = sort
    @order           = order
    @calc_found_rows = 'Yes'
    @fields          = fields
    @filters         = []
  end

  def add_filter(name, assertion, equals)
    @filters << Filter.new(name, assertion, equals)
  end

  def as_json(*args)
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

  def to_json(*)
    JSON(as_json)
  end
end
