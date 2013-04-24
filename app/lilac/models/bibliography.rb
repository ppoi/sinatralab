
module Lilac
  module Models

    class Label < Sequel::Model

      def self.get(name)
        Label.dataset.where(:name =>name).first
      end

      def self.all
        Label.dataset.order(:name).all
      end
    end

    class Author < Sequel::Model
    end

    class Bibliography < Sequel::Model
      one_to_many :authors, :class=>'Lilac::Models::BibAuthor'

      def self.[](*args)
        if args.length == 1 && (i = args.at(0)) && i.is_a?(Integer)
          result = eager_graph(:authors=>:author).where(:bibliographies__id=>i).all
          if result.empty?
            nil
          else
            result[0]
          end
        else
          super
        end
      end

      def self.search(args={}, limit=nil, offset=nil)
        query = db[:bibliographies___b].distinct.select(:b__id)
        if args.key?(:label)
          query = query.where(:b__label=>args[:label])
        end
        if args.key?(:author_id)
          query = query.join(:bib_authors___ba, {:ba__bibliography_id=>:b__id, :ba__author_id=>args[:author_id]})
        end
        if args.key?(:keyword)
          keyword = args[:keyword]
          bib_condition = Sequel.lit("MATCH(`b`.`title`, `b`.`subtitle`) AGAINST (?)", keyword)
          if args.key?(:author_id)
            query = query.where(bib_condition)
          else
            query = query.join(:bib_authors___ba, :ba__bibliography_id=>:b__id)
            query = query.where(
               {:ba__author_id=>db[:authors___a].distinct.select(:a__id)
                 .join_table(:inner, :authors___as){ |j, lj, js|
                   {:a__id=>:as__id} | (Sequel.~(:as__synonym_key=>0) & {:a__synonym_key=>:as__synonym_key})
                 }
                 .where(Sequel.lit("MATCH(`a`.`name`) AGAINST (?)"), keyword)
               } | bib_condition)
          end
        end
        query = query.order(:b__title, :b__subtitle).limit(limit, offset)
        eager_graph(:authors=>:author)
          .where(:bibliographies__id=>query)
          .all
      end
    end

    class BibAuthor < Sequel::Model
      many_to_one :author
    end

  end
end
