Sequel.migration do
  change do
    create_table(:votes) do
      primary_key :id
      String :email, null: false
      String :dip, null: false
      foreign_key(:dip_id, :dips, key: :id)
      unique([:email, :dip_id])
      unique([:email, :dip])
    end
  end
end