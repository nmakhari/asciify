require 'rails_helper'

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

  # describe "POST /create" do
  #   it "should make a new upload" do
  #     # https://stackoverflow.com/questions/47206796/no-decode-delegate-for-this-image-format-error-blob-c-blobtoimage-348
  #     file = fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'upload', 'valid_image.png'), 'image/png')
  #     expect {
  #       post '/uploads', params: { upload: {title: "sample title", image: file}}
  #     }.to change(Upload, :count).by(1)
  #   end

  #   context "image to ascii" do
  #     it "should create a string with width 150 ascii chars" do
  #     end
  #   end
  # end
end
