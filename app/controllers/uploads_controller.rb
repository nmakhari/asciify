class UploadsController < ApplicationController
  def index
    @uploads = Upload.all
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def info
  end

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params.merge!(ascii: "ASCIIFIED STRING HERE"))
    if @upload.save
      redirect_to @upload
    else
      render('new')
    end
  end

  private
  def upload_params
    params.require(:upload).permit(:title, :image)
  end
end
