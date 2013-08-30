require "filternator/version"
require "filternator/filter"
require "filternator/apply_filter"
require "filternator/pagination"

module Filternator

  def self.new(options = {})
    Filter.new(options)
  end

end
