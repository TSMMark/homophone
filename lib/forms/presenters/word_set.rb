require "uri"
require_relative "../../form/extensions/presenter"

module Presenters
  class WordSets < Form::Base

    include Form::Extensions::Presenter

    DEFAULT_PER_PAGE = 16
    MAX_PER_PAGE = 100

    attribute(:query)
    attribute(:query_type)

    def pagination_params(page)
      super.merge({
        :q => query,
        :type => query_type
      })
    end

    def results
      @results ||= paginated_dataset.all
    end

    def paginated_dataset
      filtered_dataset.order("min(lower(words.text)) ASC")
                      .limit(per_page)
                      .offset(start)
    end

    def filtered_dataset
      dataset.joins(:words).
              select("word_sets.*, min(lower(words.text))").
              where("lower(words.text) LIKE ?", Utils::Queries.ilike_string(query, query_type).downcase).
              group("word_sets.id")
    end

    def count
      @count ||= begin
        sql = %Q(SELECT count(*) FROM (#{filtered_dataset.to_sql}) AS results)
        values_array = WordSet.connection.execute(sql).values.first
        values_array.first.to_i
      end
    end

  end
end
