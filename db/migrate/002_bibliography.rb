Sequel.migration do
  up do
    create_table :labels, :engine=>'mroonga', :charset=>'utf8', :collate=>'utf8_bin' do
      Integer :id, :auto_increment=>true, :primary_key=>true
      String :name, :size=>128, :unique=>true
      String :website, :size=>2048
      String :publisher, :size=>128
      String :note, :text=>true
    end

    create_table :authors, :engine=>'mroonga', :charset=>'utf8', :collate=>'utf8_bin' do
      Integer :id, :auto_increment=>true, :primary_key=>true
      String :name, :size=>128
      String :website, :size=>2048, :default=>''
      String :twitter, :size=>128, :default=>''
      Integer :synonym_key, :default=>0
      String :note, :text=>true
      index(:synonym_key)
    end
    run "CREATE FULLTEXT INDEX idx_authors_name ON authors(name) COMMENT 'parser \"TokenBigramSplitSymbolAlphaDigit\"';"

    create_table :bibliographies, :engine=>'mroonga', :charset=>'utf8', :collate=>'utf8_bin' do
      Integer :id, :auto_increment=>true, :primary_key=>true
      String :isbn, :size=>64
      String :label, :size=>128
      String :title, :text=>true
      String :subtitle, :text=>true
      Integer :price, :default=>0
      Date :publication_date, :null=>true
      index(:publication_date)
      index(:label)
      index(:isbn)
    end
    run "CREATE FULLTEXT INDEX idx_bibliographies_name ON bibliographies(title, subtitle) COMMENT 'parser \"TokenBigramSplitSymbolAlphaDigit\"';"

    create_table :bib_authors, :engine=>'mroonga', :charset=>'utf8', :collate=>'utf8_bin' do
      Bignum :id, :auto_increment=>true, :primary_key=>true
      Integer :role
      foreign_key :bibliography_id, :bibliographies, :null=>false
      foreign_key :author_id, :authors, :null=>false
      index(:bibliography_id)
      index(:author_id)
    end
  end

  down do
    drop_table :bib_authors
    drop_table :bibliographies
    drop_table :authors
    drop_table :labels
  end
end

