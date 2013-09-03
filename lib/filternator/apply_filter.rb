require "forwardable"

module Filternator
  class ApplyFilter
    extend Forwardable

    attr_reader :filterer, :params

    def initialize(filterer, params)
      @filterer = filterer
      @params = params
    end

    def_delegators :filterer, :scope_name, :scope, :all_filters, :presenter, :default_filter

    def as_json(*args)
      {
        scope_name => presenters.as_json(*args),
        :meta => {
          :filters        => all_filters,
          :applied_filter => filter,
          :pagination     => pagination.as_json,
        },
      }
    end

    def count
      filtered_scope.count
    end

    def presenters
      paginated_scope.map(&presenter)
    end

    def pagination
      Pagination.new(paginated_scope)
    end

    def paginated_scope
      filtered_scope.paginate(page: params[:page])
    end

    def filter
      params[:filter].presence || default_filter
    end

    def filtered_scope
      if valid_filter?
        # ignore 'all' on relations
        if scope.is_a?(::ActiveRecord::Relation) && filter.to_s == "all"
          scope
        else
          scope.public_send(filter)
        end
      else
        scope
      end
    end

    def valid_filter?
      filter.present? && all_filters.include?(filter)
    end

  end
end
