# ActiveRecordBetterDependentErrorMessages
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "active_record_better_dependent_error_messages"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install active_record_better_dependent_error_messages
```

Include it in the models where you want it to inspect the relationships upon destroy like this:
```ruby
class MyModel < ApplicationRecord
  include ActiveRecordBetterDependentErrorMessages::DestroyModule
end
```

You can add a custom error message like this:
```yaml
en:
  activerecord:
    errors:
      models:
        user:
          attributes:
            base:
              cannot_delete_because_of_restriction: Cannot delete because the user has dependent %{association_name}
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
