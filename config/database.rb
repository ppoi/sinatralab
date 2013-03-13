DB = case APP_ENVIRONMENT
  when :development then Sequel.connect("mysql2://localhost/lilac_test", :user=>"lilac_test", :password=>"lilac_test")
  when :production  then Sequel.connect("mysql2://localhost/lilac_test", :user=>"lilac_test", :password=>"lilac_test", :logger=>Lilac::Logging.instance)
  when :test        then Sequel.connect("mysql2://localhost/lilac_test", :user=>"lilac_test", :password=>"lilac_test")
end

