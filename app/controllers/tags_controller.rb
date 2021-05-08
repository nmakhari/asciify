class TagsController < ApplicationController
  def show
    @uploads = Tag.find(params[:id]).uploads
  end
end
