# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'lilac/models/bibliography'

describe "Lilac::Models::Bibliography model" do

  it 'can create' do
    entity = Lilac::Models::Bibliography.new
    entity.should_not be_nil
  end

  it 'can add association' do
    bib_author = Lilac::Models::BibAuthor.new
    bib_author.author = create(:author_abc)

    entity = create(:bib_abc)
    entity.add_author(bib_author)

    b = Lilac::Models::Bibliography[entity.id]
    b.should_not be_nil
    authors = b.authors
    authors.should_not be_nil
    authors.should have(1).items
    authors[0].should_not be_nil
    authors[0].bibliography_id.should eq(entity.id)
    authors[0].author_id.should eq(bib_author.author.id)
    authors[0].author.should_not be_nil
    authors[0].author.name.should eq('著者ABC')
    authors[0].author.synonym_key.should eq(39)

  end

  it 'return nil if not exists.' do
    entity = Lilac::Models::Bibliography[393939393]
    entity.should be_nil
  end

  it 'query!' do
    bib_abc = create(:bib_abc)
    bib_ghi = create(:bib_ghi)
    author_abc = create(:author_abc)
    author_bcd = create(:author_bcd)
    author_def = create(:author_def)
    author_ghi = create(:author_ghi)

    bib_auth = create(:bib_author_author)
    bib_auth.author = author_abc
    bib_abc.add_author(bib_auth)
    bib_auth = create(:bib_author_illustrator)
    bib_auth.author = author_def
    bib_abc.add_author(bib_auth)

    bib_auth = create(:bib_author_author)
    bib_auth.author = author_abc
    bib_ghi.add_author(bib_auth)
    bib_auth = create(:bib_author_illustrator)
    bib_auth.author = author_ghi
    bib_ghi.add_author(bib_auth)

    result = Lilac::Models::Bibliography.search({:keyword=>'ABC', :label=>'レーベルA'})
    p result

  end

  it 'query by author_id' do
    bib_abc = create(:bib_abc)
    bib_ghi = create(:bib_ghi)
    author_abc = create(:author_abc)
    author_bcd = create(:author_bcd)
    author_def = create(:author_def)
    author_ghi = create(:author_ghi)

    bib_auth = create(:bib_author_author)
    bib_auth.author = author_abc
    bib_abc.add_author(bib_auth)
    bib_auth = create(:bib_author_illustrator)
    bib_auth.author = author_def
    bib_abc.add_author(bib_auth)

    bib_auth = create(:bib_author_author)
    bib_auth.author = author_abc
    bib_ghi.add_author(bib_auth)
    bib_auth = create(:bib_author_illustrator)
    bib_auth.author = author_ghi
    bib_ghi.add_author(bib_auth)

    result = Lilac::Models::Bibliography.search(:author_id=>author_def.id)
    p result
  end


end
