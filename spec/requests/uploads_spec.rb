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
      it 'should create a string with the specified width' do
        upload = Upload.new(title: "Sample title", ascii: "Loading Ascii ...")
        file = Rails.root.join('spec', 'support', 'assets', 'upload', 'valid_image.png')
        image = ActiveStorage::Blob.create_after_upload!(
          io: File.open(file, 'rb'),
          filename: 'valid_image.png',
          content_type: 'image/png'
        ).signed_id
        upload.image = image
        upload.save!

        # manually kick off background job here as it would be in the controller
        allow_any_instance_of(ActiveStorage::Service::DiskService).to receive(:path_for).and_return(file)
        Upload.delay.generate_ascii_string(upload.id)
        ascii_string = Upload.find(upload.id).ascii
        expect(ascii_string.split("\n").first.length).to eq(Upload::IMG_WIDTH)
      end
    end
  end
end
