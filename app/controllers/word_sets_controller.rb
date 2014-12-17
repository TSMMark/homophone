class WordSetsController < ApplicationController
  include WordSetsHelper

  before_action :set_word_set, only: [:show, :random]
  load_and_authorize_resource only: [:new, :create, :edit, :update, :destroy]

  def index
    @query = params[:q].blank? ? nil : params[:q]
    @query_type = params[:type] || "include"

    if @query
      WordSet.current_query = @query
      WordSet.current_query_type = @query_type
    end

    @presenter = Presenters::WordSetPresenter.new(params.merge({
      :dataset => WordSet,
      :query => @query,
      :query_type => @query_type,
      :path => word_sets_path
    }))
  end

  def show; end

  def from_slug
    @word_set = WordSet.from_slug(params[:slug])

    respond_to do |format|
      format.html { render action: 'show' }
    end
  end

  def pick_random
    @word_set = WordSet.sample

    if @word_set
      redirect_to "/random/#{@word_set.id}"
    else
      redirect_to root_path, info: "No homophones yet"
    end
  end

  def random
    WordSet.current_query = ""
    WordSet.current_query_type = ""
  end

  def new
    @word_set = WordSet.new
  end

  def edit; end

  def create
    @word_set = WordSet.new(word_set_params)

    respond_to do |format|
      if @word_set.save
        Slug.create_for_word_set(@word_set)
        format.html { redirect_to @word_set, info: 'Word set was successfully created.' }
        format.json { render action: 'show', status: :created, location: @word_set }
      else
        format.html { render action: 'new' }
        format.json { render json: @word_set.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    current_slug = Slug.value_for_word_set(@word_set)

    respond_to do |format|
      if @word_set.update(word_set_params)
        @word_set.reload

        if Slug.value_for_word_set(@word_set) != current_slug
          Slug.create_for_word_set(@word_set)
        end

        format.html { redirect_to @word_set, info: 'Word set was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @word_set }
      else
        format.html { render action: 'edit' }
        format.json { render json: @word_set.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # TODO: Test this.
    # @word_set.definitions.destroy_all
    @word_set.destroy
    respond_to do |format|
      format.html { redirect_to browse_path, warning: "Word set deleted." }
      format.json { head :no_content }
    end
  end


  private


  def set_word_set
    @word_set = WordSet.find(params[:id])
  end

  def word_set_params
    params.require(:word_set).permit(words: [[:text, :display_text]]).tap do |p|
      p[:words] = p[:words].reject do |w|
        w[:text].blank?
      end.map do |w|
        w[:word_set_id] = @word_set && @word_set.id
        w[:word_set] = @word_set
        Word.new(w)
      end
    end
  end
end
