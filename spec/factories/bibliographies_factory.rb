# -*- encoding : utf-8 -*-

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :author do
    factory :author_abc do
      name '著者ABC'
      synonym_key 39
    end

    factory :author_bcd do
      name '著者BCD'
      synonym_key 39
    end

    factory :author_def do
      name '著者DEF'
    end

    factory :author_ghi do
      name '著者GHI'
    end
  end

  factory :bib_author do
    factory :bib_author_author do
      role 0
    end
    factory :bib_author_illustrator do
      role 1
    end
    factory :bib_author_editor do
      role 2
    end
  end

  factory :bibliography do
    factory :bib_abc do
      title '書籍ABC'
      subtitle 'DEF'
      isbn '393-0000000001'
      label 'レーベルA'
    end

    factory :bib_ghi do
      title '書籍GHI'
      subtitle 'JKL'
      isbn '393-0000000002'
      label 'レーベルA'
    end
  end
end
