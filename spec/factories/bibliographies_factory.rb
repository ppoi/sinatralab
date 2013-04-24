# -*- encoding : utf-8 -*-
require 'lilac/models/bibliography'

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :author, :class=>Lilac::Models::Author do
    factory :author_abc do
      name '著者ABC'
      synonym_key 39
    end

    factory :author_bcd, :class=>Lilac::Models::Author do
      name '著者BCD'
      synonym_key 39
    end

    factory :author_def, :class=>Lilac::Models::Author do
      name '著者DEF'
    end

    factory :author_ghi, :class=>Lilac::Models::Author do
      name '著者GHI'
    end
  end

  factory :bib_author, :class=>Lilac::Models::BibAuthor do
    factory :bib_author_author do
      role 0
    end
    factory :bib_author_illustrator, :class=>Lilac::Models::BibAuthor do
      role 1
    end
    factory :bib_author_editor, :class=>Lilac::Models::BibAuthor do
      role 2
    end
  end

  factory :bibliography, :class=>Lilac::Models::Bibliography do
    factory :bib_abc do
      title '書籍ABC'
      subtitle 'DEF'
      isbn '393-0000000001'
      label 'レーベルA'
    end

    factory :bib_ghi, :class=>Lilac::Models::Bibliography do
      title '書籍GHI'
      subtitle 'JKL'
      isbn '393-0000000002'
      label 'レーベルA'
    end
  end
end
