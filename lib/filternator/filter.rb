module Filternator
  class Filter

    attr_reader :scope, :scope_name, :presenter, :all_filters, :default_filter

    def initialize(options = {})
      @scope          = options.fetch(:scope)
      @scope_name     = options.fetch(:scope_name)     { derive_scope_name }
      @presenter      = options.fetch(:presenter)      { null_presenter }
      @all_filters    = options.fetch(:all_filters)    { scope.all_filters }
      @default_filter = options.fetch(:default_filter) { "all" }
    end

    def stats
      pairs = all_filters.map { |filter|
        result = apply(filter: filter).count
        result = result.values.inject(:+) if result.is_a?(Hash) # ActiveRecord `group by` fix
        [ filter, result ]
      }
      Hash[pairs]
    end

    def apply(params)
      ApplyFilter.new(self, params)
    end

    private

    def derive_scope_name
      scope.model_name.element.pluralize
    end

    def null_presenter
      lambda { |item| item }
    end

  end
end
