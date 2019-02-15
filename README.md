SampleFilter
===========

SampleFilter is a Rails Engine plugin that makes to filter and sort ActiveRecord lists.

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'sample_filter'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sample_filter
```

Install javascripts air-datepicker dependency:
```bash
$ yarn add air-datepicker
```

Require SampleFilter javascripts with air-datepicker dependency in your `app/assets/javascripts/application.js`:
``` javascript
//= require jquery
//= require air-datepicker/dist/js/datepicker.min
//= require sample_filter/script
```
And then require styles in your `app/assets/stylesheets/application.css`:
``` css
/*
 *= require air-datepicker/dist/css/datepicker.min
 *= require sample_filter/style
 */
```

## Usage

### Configuring Models
The SampleFilter method in your models accepts options to configure its modules. For example:
```ruby
class Entity < ApplicationRecord
  sample_filter(
    {
      title: { type: :string },
      amount: { type: :number },
      created_at: { type: :date, default_value: { from: '09.10.2016', to: '17.12.2023' } },
      kind: {
        type: :list,
        values: { red: 1, green: 2 },
        default_value: 2
      },
      status: {
        type: :list,
        values: [:active, :inactive],
        default_value: :inactive
      },
      confirmed: { type: :boolean, default_value: true },
      sort: {
        type: :sorting,
        values: [:id, :amount, :created_at],
        default_value: 'amount_desc',
        hidden_input: true # this option transform select to hidden input in form
      }
    }
  )
end
```

for update values on demand in list or sorting fields, call method
```ruby
Entity.filter_update_value(:kind, [:black, :white])
# or hash
Entity.filter_update_value(:kind, { black: 3, white: 4 })
```

### Form helpers
```ruby
<%= form_for_filter(Entity, as: :sample_filter, block: :after, html: { method: :get, id: :sample_filter}) do %>
  <%= label_tag 'custom_input' %>
  <%= text_field_tag 'custom_input' %>
<% end %>
```

also `form_for_filter` include form action options:
```ruby
options[:url] ||= url_for(
  :controller => controller.controller_name,
  :action => controller.action_name
)
```

Table sorting link
``` ruby
<%= sort_link(Entity, :sorting_field) %>
```

### Controller
In your `index` method:
```ruby
@entites = Entity.filtered(params[:sample_filter])
```

### I18n
SampleFilter uses labels with I18n:
```yaml
en:
  sample_filter:
    entity:
      fields:
        title: Title
        amount: Amount
        created_at: Created At
        kind: Type
        status: Status
        confirmed: Confirmed status
        sort: Sorting
      list:
        kind:
          all_item: All colors
          red: Red color
          green: Green color
        status:
          all_item: All statuses
          active: Active status
          inactive: Inactive status
        confirmed:
          all_item: All
          'true': Confirmed
          'false': Unconfirmed
        sort:
          id:
            asc: id ↓
            desc: id ↑
          created_at:
            asc: created_at ↓
            desc: created_at ↑
          amount:
            asc: amount ↓
            desc: amount ↑
      buttons:
        submit: Submit
        clear_form: Clear Form
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

