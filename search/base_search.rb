require_relative './filter'

class BaseSearch
  attr_accessor :start, :limit, :sort, :order,
                :calc_found_rows, :fields, :filters

  def self.fields
    raise 'Fields called on base class'
  end

  def initialize(start = 0, limit = 10, sort = nil, order = :asc)
    @start           = start
    @limit           = limit
    @sort            = sort
    @order           = order
    @calc_found_rows = 'Yes'
    @fields          = self.class.fields
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
