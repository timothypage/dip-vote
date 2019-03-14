Sequel.migration do
  change do
    create_table(:dips) do
      primary_key :id
      String :name, null: false
      foreign_key(:contestant_id, :contestants, key: :id)
    end
  end
end