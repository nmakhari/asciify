require 'rails_helper'
require 'rmagick'

RSpec.describe "Uploads", type: :request do
  describe "GET /index" do
    it "should return 200" do
      get '/uploads'
      expect(response.status).to eq(200)
    end
  end

  describe "GET /new" do
    it "should return 200" do
      get '/uploads/new'
      expect(response.status).to eq(200)
    end
  end

  describe "GET /show" do
    it "should return 200 with valid id" do
      file = Rails.root.join('spec', 'support', 'assets', 'upload', 'valid_image.png')
      image = ActiveStorage::Blob.create_after_upload!(
        io: File.open(file, 'rb'),
        filename: 'valid_image.png',
        content_type: 'image/png'
      ).signed_id
      sample_upload = Upload.new(title: "Sample Upload", ascii: "Sample ascii string", image: image)
      sample_upload.save!
      get "/uploads/#{sample_upload.id}"
      expect(response.status).to eq(200)
    end
  end

  describe "POST /create" do
    context "image to ascii" do
      # There are with sending images through rspec to the post method, possibly related with the Magick installation
      # Thus, creating the image here and mocking the :prepare_image method allows testing of image -> ascii conversion
      it "should create a string with width 150 ascii chars" do
        # Perform the operations in :prepare_image, then provide it as a mock return
        img = Magick::ImageList.new(Rails.root.join('spec', 'support', 'assets', 'upload', 'valid_image.png'))
        width = img.columns
        height = img.rows
        # resize the image
        ratio = (height.to_f / width) / 2.to_f
        new_width = 150
        new_height = new_width * ratio
        img.scale!(new_width, new_height)
        # greyscale the image
        img.quantize(256, Magick::GRAYColorspace)
        allow_any_instance_of(UploadsController).to receive(:prepare_image).and_return(img)
        
        ascii_string = UploadsController.new.send(:convert_to_ascii)
        expect(ascii_string.split("\n").first.length).to eq(150)
        expect(ascii_string.split("\n").length()).to eq(new_height.floor())
      end
    end
  end
end
