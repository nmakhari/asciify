require 'rails_helper'

# https://channaly.medium.com/how-to-work-with-active-storage-attachment-in-rspec-23bcc49712d6

RSpec.describe Upload, type: :model do

  let(:example_upload) { described_class.new( title: "SampleShortTitle",
                                              ascii: "SampleAscii\nString") }
  
  before do 
    # fetch image and add to sample upload
    file = Rails.root.join('spec', 'support', 'assets', 'upload', 'valid_image.png')
    image = ActiveStorage::Blob.create_after_upload!(
      io: File.open(file, 'rb'),
      filename: 'valid_image.png',
      content_type: 'image/png'
    ).signed_id

    example_upload.image = image
    example_upload.save!
  end

  it "is valid with title, ascii string and image of correct size" do
    expect(example_upload).to be_valid
  end

  it "is not valid without a title" do
    example_upload.title = nil
    expect(example_upload).to_not be_valid
  end

  it "is not valid with a title longer than 30 chars" do 
    example_upload.title = "1234567890123456789012345678901"
    expect(example_upload).to_not be_valid
  end

  it "is not valid without an ascii string" do
    example_upload.ascii = nil
    expect(example_upload).to_not be_valid
  end

  it "is not valid without and image" do
    no_image_upload = described_class.new(
      title: "HasNoAttachment",
      ascii: "This is still here"
    )
    expect(no_image_upload).to_not be_valid
  end

  it "is not valid without a file in jpg or png format" do
    # fetch text file and add to sample upload
    file = Rails.root.join('spec', 'support', 'assets', 'upload', 'invalid_format.txt')
    text_file = ActiveStorage::Blob.create_after_upload!(
      io: File.open(file, 'rb'),
      filename: 'invalid_format.txt',
      content_type: 'text/plain'
    ).signed_id

    example_upload.image = text_file
    expect(example_upload).to_not be_valid
  end

  context "when the image is larger than 10mb" do

    before do
      allow(example_upload.image).to receive(:byte_size).and_return(11.megabytes)
    end

    it "should be invalid" do
      expect(example_upload).to_not be_valid
    end
  end
end
