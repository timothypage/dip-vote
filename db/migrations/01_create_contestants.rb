Sequel.migration do
  change do
    create_table(:contestants) do
      primary_key :id
      String :name, null: false
    end
  end
end