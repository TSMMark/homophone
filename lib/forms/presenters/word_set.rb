module Presenters
  class WordSetPresenter < Form::Base

    include Form::Extensions::Presenter

    DEFAULT_PER_PAGE = 30

    attribute(:query)
    attribute(:query_type)

    def results
      @results ||= filtered_dataset.all
    end

    def filtered_dataset
      word_sets = dataset

      word_sets_ids = Word.where("text ILIKE ?", Utils::Queries.ilike_string(query, query_type)).
                           select("word_set_id, min(lower(text)) as lower_text").
                           order("lower_text ASC").
                           group(:word_set_id).
                           limit(per_page)

      word_sets_ids = word_sets_ids.map(&:word_set_id)

      word_sets.where(:id => word_sets_ids)
    end

  end
end
