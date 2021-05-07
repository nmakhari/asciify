json.uploads do
    json.array!(@uploads) do |upload|
        json.title upload.title
        json.url upload_path(upload)
    end
end

json.tags do
    json.array!(@tags) do |tag|
        json.title tag.title
        # json.url tag_path(tag)
    end
end