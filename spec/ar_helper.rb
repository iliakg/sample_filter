require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'postgresql', database: 'sample_filter_test'
ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Migration.create_table :entities, force: true do |t|
  t.string :title
  t.integer :amount
  t.datetime :created_at
  t.string :status
  t.integer :kind
  t.boolean :confirmed
end
