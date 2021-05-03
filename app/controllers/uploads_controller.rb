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
  end

  def create
    @upload = Upload.new(upload_params)

    @upload.save
    redirect_to @upload
  end

  private
  def upload_params
    params.require(:upload).permit(:title)
  end
end
