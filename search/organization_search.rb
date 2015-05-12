require_relative './filter'
require_relative './organization_field'

class OrganizationSearch
  attr_accessor :start, :limit, :sort, :order,
                :calc_found_rows, :fields, :filters

  class << self
    def client
      @client ||= OrganizationClient.new
    end

    def find(ids)
      ids_array = Array.wrap(ids)
      results = client.where(id: ids)
      ids_array.length = 1 ? results.first : results
    end
  end

  def initialize(start = 0, limit = 10, sort = nil, order = :asc, fields = OrganizationField.all)
    @start           = start
    @limit           = limit
    @sort            = sort
    @order           = order
    @calc_found_rows = 'Yes'
    @fields          = fields
    @filters         = []
  end

  def add_filter(name, assertion, equals)
    @filters << Filter.new(filter_name(name), assertion, filter_value(equals))
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

  private

  def filter_name(name)
    OrganizationField::FIELDS[name]
  end

  def filter_value(value)
    {

    }[value.to_sym] || value
  end
end
