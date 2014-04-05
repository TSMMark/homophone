class WordSetsController < ApplicationController
  include WordSetsHelper

  before_action :set_word_set, only: [:show, :edit, :update, :destroy, :random]

  def index
    @query = params[:q].blank? ? nil : params[:q]
    @query_type  = params[:type] || "include"

    if @query
      WordSet.current_query = @query
      @word_sets = WordSet.search_for(@query, @query_type)
    else
      @word_sets = WordSet.with_words
    end
  end

  def show
  end

  def pick_random
    redirect_to "/random/#{WordSet.sample.id}"
  end
  def random
  end

  # GET /word_sets/new
  def new
    @word_set = WordSet.new
  end

  # GET /word_sets/1/edit
  def edit
  end

  # POST /word_sets
  # POST /word_sets.json
  def create
    @word_set = WordSet.new(word_set_params)

    respond_to do |format|
      if @word_set.save
        format.html { redirect_to @word_set, notice: 'Word set was successfully created.' }
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
        format.html { redirect_to @word_set, notice: 'Word set was successfully updated.' }
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
      format.html { redirect_to word_sets_url }
      format.json { head :no_content }
    end
  end

  def card_ad_tools
    @card_ad_tools ||=  AdTools.new(
                          default_format: "horizontal",
                          format_sequence: %w(horizontal auto))
  end
  helper_method :card_ad_tools
  
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
