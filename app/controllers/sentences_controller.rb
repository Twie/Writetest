class SentencesController < ApplicationController
  before_action :set_sentence, only: [:show, :edit, :update, :destroy]
  before_filter :http_basic_auth, only: [:chapters, :chapters_download]
  before_filter :confirm_logged_in
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
    @group_id = params[:gid]
    @sentence = Sentence.new
  end

  # GET /sentences/1/edit
  def edit
  end

  # POST /sentences
  # POST /sentences.json
  def create
    @sentence = current_user.sentences.new(sentence_params)
    if @sentence.save
      redirect_to :root, notice: 'Sentence was successfully created.'
    else
      @group_id = sentence_params[:group_id]
      render :new
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
  end

  def chapters_download
    group  = Group.find(params[:group_id])
    data = group.sentences.all.map(&:content).compact.join("\n")
    send_data data, :filename => "{group.name}.txt"
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sentence
    @sentence = Sentence.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sentence_params
    params.require(:sentence).permit(:content,:group_id)
  end

  def http_basic_auth
    authenticate_or_request_with_http_basic do |name, password|
      (name == 'admin' && password == 'admin')
    end
  end
end
