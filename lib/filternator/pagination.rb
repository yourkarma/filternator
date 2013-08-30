module Filternator
  class Pagination

    attr_reader :scope

    def initialize(scope)
      @scope = scope
    end

    def as_json(*)
      {
        total:          scope.total_entries,
        total_pages:    scope.total_pages,
        first_page:     scope.current_page == 1,
        last_page:      scope.next_page.blank?,
        current_page:   scope.current_page,
        previous_page:  scope.previous_page,
        next_page:      scope.next_page,
        out_of_bounds:  scope.out_of_bounds?,
        offset:         scope.offset
      }
    end

  end
end
