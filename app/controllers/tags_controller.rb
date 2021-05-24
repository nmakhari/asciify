class TagsController < ApplicationController
  def show
    @pagy, @uploads = pagy(Tag.find(params[:id]).uploads.with_attached_image.all.reverse_order, items: 30)
  end
end
