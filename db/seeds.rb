["art", "music", "sport", "tech"].each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end
