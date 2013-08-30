# Filternator

A very basic gem for generating JSON responses for collections.

Currently supported:

* Pagination (via will_paginate)
* Simple Filters

Not supported:

* Combining multiple filters
* Filters with parameters

We use this gem in production, but it's uses are very specific to what we use. YMMV.

## Installation

Add this line to your application's Gemfile:

    gem 'filternator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filternator

## Usage

Given a model:

``` ruby
class User < ActiveRecord::Base

  def self.all_filters
    %w(all paying beta_users)
  end

  def self.paying
    where(paying: true)
  end

  def self.beta_users
    where(beta: true)
  end

  def self.visible
    where(visible: true)
  end

end
```

Then you can create a filter in the controller:

``` ruby
def index
  render json: filter.apply(params)
end

private

def filter
  Filternator.new(scope: User.visible)
end
```

And you can execute it, like this:

``` ruby
get :index, filter: "all", "page" => 2
expect(response.body).to eq({
  users: [
    {
      id:     31,
      email:  "jennifer@example.org"
      # etc...
    }
  },
  meta: {
    filters: ["all", "paying", "beta_users"],
    applied_filter: "all",
    pagination: {
      total:        31,
      total_pages:  2,
      first_page:   false,
      last_page:    true,
      # and some more
    }
  }
}.to_json)
```

### Pagination

You can pass the pagination options directly into will_paginate's view helper.

``` erb
<%= will_paginate OpenStruct.new(@user_response.body["meta"]["pagination"]) %>
```

(you should probably clean this up, but you get the point)

### Stats

You can also generate an overview of the counts of each filter.

``` ruby
# in your controller
def stats
  render json: filter.stats
end
```

Then the output looks something like this:

``` ruby
get :stats
expect(response.body).to eq({
  all:         31,
  paying:      4,
  beta_users:  13,
}.to_json)
```

## Configuration

There are a bunch of ways to configure the filter.

### Presenters

Use a presenter to change the output of the collection, by giving something that
can be mapped on each item.

``` ruby
UserDecorator = Struct.new(:user) do

  def self.to_proc
    method(:new).to_proc
  end

  def as_json(*)
    { name: user.name, email: user.email }
  end

end

filter = Filternator.new(scope: User, presenter: UserDecorator)
```

### Scope name

By default, the name of the results is the plural of the model's name. You can
change it by providing the `:scope_name` option.

``` ruby
filter = Filternator.new(scope: User.admins, scope_name: "administrators")
```

### All filters

In the example mentioned above, I defined the list of available methods on the
class. You can also change the available filters per filterer, by supplying the
`:all_filters` option.

``` ruby
# prohibits the access to the `paying`-scope.
filter  = Filternator.new(scope: User, all_filters: %w(all beta_users))
```

### Default filter

Note for ActiveRecord 3: `all` will not return a scope, but an array and will
not work. You use `.scoped` instead. You can also override `.all` to return
`.scoped`, but that might break some of your code. If you choose a different
name than `all`, you need to specify it, and allow it with `all_filters`.

``` ruby
filter = Filternator.new(scope: User, default_filter: "scoped", all_filters: %w(scoped other))
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
