class WordSetsController < ApplicationController
  include WordSetsHelper

  before_action :set_word_set, only: [:show, :random]
  load_and_authorize_resource only: [:new, :create, :edit, :update, :destroy]

  def index
    @query = params[:q].blank? ? nil : params[:q]
    @query_type  = params[:type] || "include"

    if @query
      WordSet.current_query       = @query
      WordSet.current_query_type  = @query_type
      @word_sets = WordSet.search_for(@query, @query_type)
    else
      @word_sets = WordSet.with_words
    end
  end

  def show; end

  def pick_random
    redirect_to "/random/#{WordSet.sample.id}"
  end
  def random
    WordSet.current_query       = ""
    WordSet.current_query_type  = ""
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

  # PATCH/PUT /word_sets/1
  # PATCH/PUT /word_sets/1.json
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

  # DELETE /word_sets/1
  # DELETE /word_sets/1.json
  def destroy
    @word_set.destroy
    respond_to do |format|
      format.html { redirect_to browse_path, warning: "Word set deleted." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_word_set
      @word_set = WordSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_set_params
      params.require(:word_set).permit(:visits, words: []).tap do |p|
        p[:words].reject!(&:empty?)
      end
    end
end
