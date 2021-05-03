class UploadsController < ApplicationController
  def index
  end

  def show
  end

  def info
  end

  def new
  end

  def create
    render plain: params[:upload].inspect
  end
end
