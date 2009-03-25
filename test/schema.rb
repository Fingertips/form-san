ActiveRecord::Schema.define(:version => 1) do
  create_table :books do |t|
    t.string :title
    t.string :isbn
    t.boolean :published, :default => false
  end
end