class WordsController < ApplicationController
  before_action :set_word, only: [:show]
  load_and_authorize_resource only: [:edit, :update, :destroy]

  def show
    respond_to do |format|
      format.html
      format.popover
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word.word_set, info: 'Word was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @word }
      else
        format.html { render action: 'edit' }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end


  protected


  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:text, :display_text).tap do |p|
      p[:display_text] = nil if p[:display_text].blank?
    end
  end

end
