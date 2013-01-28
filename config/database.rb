Sequel::Model.plugin :schema
Sequel::Model.plugin :json_serializer, :naked=>true
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
DB = case LILAC_ENVIRONMENT
  when :development then Sequel.connect("mysql2://localhost/lilac_test", :user=>"lilac_test", :password=>"lilac_test")
  when :production  then Sequel.connect("mysql2://localhost/lilac")
  when :test        then Sequel.connect("mysql2://localhost/lilac_test", :user=>"lilac_test", :password=>"lilac_test", :encoding=>"utf8")
end

