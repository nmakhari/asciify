class UploadsController < ApplicationController
  def index
    @pagy, @uploads = pagy(Upload.with_attached_image.all.reverse_order, items: 30)
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def new
    @upload = Upload.new
  end

  def create
    # create the original object without tag string in params
    @upload = Upload.new(upload_params.merge!(ascii: "Loading Ascii ...").except(:tags_string))

    # accept a comma separated list of tags
    tag_list = upload_params[:tags_string].delete(' ').split(',')
    current_tag_titles = []
    tag_list.each do |tag|
      next if tag.in?(current_tag_titles)
      existing_tag = Tag.find_by title: tag
      if existing_tag.present?
        @upload.tags << existing_tag
        current_tag_titles.append(existing_tag.title)
      else
        new_tag = Tag.new(title: tag)
        if new_tag.save
          @upload.tags << new_tag
          current_tag_titles.append(new_tag.title)
        end
      end
    end

    if @upload.save
      # kick off background job for ascii string generation
      Upload.delay.generate_ascii_string(@upload.id)
      redirect_to @upload
    else
      render('new')
    end
  end

  def search
    @pagy, @uploads = pagy(Upload.ransack(title_cont: params[:q]).result(distinct: true), items: 30)
    @tags = Tag.ransack(title_cont: params[:q]).result(distinct: true)

    respond_to do |format|
      format.html {}
      format.json {
        @uploads = @uploads.limit(3)
        @tags = @tags.limit(3)
      }
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:title, :image, :tags_string)
  end
end
