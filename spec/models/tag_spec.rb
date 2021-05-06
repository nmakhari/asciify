require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:sample_tag) { described_class.new(title: "sample tag title") }

  context "validation" do
    before do
      sample_tag.save!
    end

    it "is valid with correct title" do
      expect(sample_tag).to be_valid
    end

    it "is not valid without title" do
      sample_tag.title = nil
      expect(sample_tag).to_not be_valid
    end

    it "is not valid with a title longer than 30 chars" do
      sample_tag.title = "1234567890123456789012345678901"
      expect(sample_tag).to_not be_valid
    end
  end


  context "association to uploads" do
    let(:sample_upload_0) { Upload.new( title: "FIRST upload title",
                                        ascii: "FIRST upload ascii string"
                                      )}

    let(:sample_upload_1) { Upload.new( title: "SECOND upload title",
                                        ascii: "SECOND upload ascii string"
                                      )}
    before do
      # fetch image and add to sample upload
      file = Rails.root.join('spec', 'support', 'assets', 'upload', 'valid_image.png')
      image = ActiveStorage::Blob.create_after_upload!(
        io: File.open(file, 'rb'),
        filename: 'valid_image.png',
        content_type: 'image/png'
      ).signed_id

      sample_upload_0.image = image
      sample_upload_1.image = image
      sample_upload_0.save!
      sample_upload_1.save!
    end

    it "should have no uploads to begin with" do
      expect(sample_tag.uploads.count).to eq(0)
    end

    it "should have both uploads associated if tag is added to them" do
      sample_upload_0.tags << sample_tag
      sample_upload_0.save!
      expect(sample_upload_0.tags.count).to eq(1)
      sample_upload_1.tags << sample_tag
      sample_upload_1.save!
      expect(sample_upload_1.tags.count).to eq(1)

      expect(sample_tag.uploads.count).to eq(2)
    end
  end
end
