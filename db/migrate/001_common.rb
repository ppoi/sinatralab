Sequel.migration do

  up do
    create_table :accounts, :charset=>'utf8', :collate=>'utf8_bin' do
      String :name, :size=>128, :primary_key=>true
      String :realname, :null=>true
      String :email_address, :size=>256
      String :library_name, :size=>256
      String :note, :size=>256
    end

    create_table :account_credentials, :charset=>'utf8', :collate=>'utf8_bin' do
      String :name, :size=>128, :primary_key=>true
      String :screen_name, :size=>256, :null=>false
      Bignum :user_id, :null=>false
      foreign_key [:name], :accounts, :on_delete=>:cascade, :on_update=>:cascade
    end
  end

  down do
    drop_table :account_credentials
    drop_table :accounts
  end
end
