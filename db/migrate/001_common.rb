Sequel.migration do

  up do
    create_table :signup_entries, :charset=>'utf8', :collate=>'utf8_bin' do
      String :id, :size=>64, :primary_key=>true
      String :email_address, :size=>256
      String :registration_timestamp, :size=>32
    end

    create_table :accounts, :charset=>'utf8', :collate=>'utf8_bin' do
      String :id, :size=>64, :primary_key=>true
      String :email_address, :size=>256
      Integer :lock_version, :default=>0
    end

    create_table :account_credentials, :charset=>'utf8', :collate=>'utf8_bin' do
      String :id, :size=>64, :primary_key=>true
      Bignum :external_id, :null=>false
      String :access_token, :size=>128
      String :access_secret, :size=>128
      foreign_key [:id], :accounts, :on_delete=>:cascade
    end
  end

  down do
    drop_table :account_credentials
    drop_table :accounts
    drop_table :signup_entries
  end
end
