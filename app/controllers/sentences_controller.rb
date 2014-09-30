class SentencesController < ApplicationController
  before_action :set_sentence, only: [:show, :edit, :update, :destroy]
  before_filter :http_basic_auth, only: [:chapters, :chapters_download]
  respond_to :html, :js

  # GET /sentences
  # GET /sentences.json

  def index
    @sentences = Sentence.all
    @sentence = Sentence.new
  end

  # GET /sentences/1
  # GET /sentences/1.json
  def show
  end

  # GET /sentences/new
  def new
    @sentence = Sentence.new
  end

  # GET /sentences/1/edit
  def edit
  end

  # POST /sentences
  # POST /sentences.json
  def create
    @sentence = Sentence.new(sentence_params)

    respond_to do |format|
      if @sentence.save
        format.html { redirect_to @sentence, notice: 'Sentence was successfully created.' }
        format.json { render :show, status: :created, location: @sentence }
        format.js
      else
        format.html { render :new }
        format.json { render json: @sentence.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  # PATCH/PUT /sentences/1
  # PATCH/PUT /sentences/1.json
  def update
    respond_to do |format|
      if @sentence.update(sentence_params)
        format.html { redirect_to @sentence, notice: 'Sentence was successfully updated.' }
        format.json { render :show, status: :ok, location: @sentence }
      else
        format.html { render :edit }
        format.json { render json: @sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sentences/1
  # DELETE /sentences/1.json
  def destroy
    @sentence.destroy
    respond_to do |format|
      format.html { redirect_to sentences_url, notice: 'Sentence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def chapters
    @total_chapters = (Sentence.count / Sentence::LINES_PER_CHAPTER)
    @total_chapters = @total_chapters + 1 if (Sentence.count % Sentence::LINES_PER_CHAPTER) != 0
  end
  
  def chapters_download
    chapter = params[:chapter]
    if chapter == "all"
      data = Sentence.all.map(&:content).compact.join("\n")
    else
      data = Sentence.offset(((chapter.to_i - 1) * Sentence::LINES_PER_CHAPTER)).limit(Sentence::LINES_PER_CHAPTER).map(&:content).compact.join("\n")   
    end
    send_data data, :filename => "chapter_#{chapter}.txt"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sentence
      @sentence = Sentence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sentence_params
      params.require(:sentence).permit(:content)
    end

    def http_basic_auth
      authenticate_or_request_with_http_basic do |name, password|
        (name == 'admin' && password == 'admin')
      end
    end
  end
