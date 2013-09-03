require "filternator"
require "active_record"
require "will_paginate/active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :widgets do |t|
  t.string :state, null: false
end

class Widget < ActiveRecord::Base
  def self.all_filters
    %w(all busy)
  end
  scope :busy, -> { where state: "busy" }
  def self.ordered
    order("state DESC")
  end
end

describe Filternator do

  before do
    Widget.delete_all
  end

  example "a basic filter" do
    Widget.create! id: 1, state: "idle"
    Widget.create! id: 2, state: "busy"
    filter = Filternator.new(scope: Widget.ordered)
    result = filter.apply(filter: "busy")
    expect(result.as_json).to eq(
      {
        "widgets" => [{
          "id" => 2,
          "state" => "busy",
        }],
        meta: {
          filters: %w(all busy),
          applied_filter: "busy",
          pagination: {
            total:          1,
            total_pages:    1,
            first_page:     true,
            last_page:      true,
            current_page:   1,
            previous_page:  nil,
            next_page:      nil,
            out_of_bounds:  false,
            offset:         0,
          }
        }
      }
    )
  end

  example "stats" do
    Widget.create! id: 1, state: "idle"
    Widget.create! id: 2, state: "busy"
    filter = Filternator.new(scope: Widget)
    expect(filter.stats).to eq(
      {
        "all" => 2,
        "busy" => 1,
      }
    )
  end

end
