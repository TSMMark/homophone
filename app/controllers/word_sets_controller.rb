class WordSetsController < ApplicationController
  include WordSetsHelper

  before_action :set_word_set, only: [:show]
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

  def show
    @random = params[:random].to_s.downcase == "true"
  end

  def pick_random
    @word_set = WordSet.sample

    if @word_set
      redirect_to word_set_path(@word_set, params: {:random => "true"})
    else
      redirect_to root_path, info: "No homophones yet"
    end
  end

  def random
    redirect_to word_set_path(params[:id], params: {:random => "true"}), status: :moved_permanently
  end

  def new
    @word_set = WordSet.new
  end

  def edit; end

  def create
    @word_set = WordSet.new(word_set_params)

    respond_to do |format|
      if @word_set.save
        format.html { redirect_to @word_set, info: 'Word set was successfully created.' }
        format.json { render action: 'show', status: :created, location: @word_set }
      else
        format.html { render action: 'new' }
        format.json { render json: @word_set.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @word_set.update(word_set_params)
        format.html { redirect_to @word_set, info: 'Word set was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @word_set }
      else
        format.html { render action: 'edit' }
        format.json { render json: @word_set.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
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
      p[:words].reject! { |w| w[:text].blank? }.map! do |w|
        w[:word_set_id] = @word_set && @word_set.id
        w[:word_set] = @word_set
        Word.new(w)
      end
    end
  end
end
