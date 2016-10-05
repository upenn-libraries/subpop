namespace :paperclip do
  desc "Recreate attachments and save them to new destination"
  task :move_attachments => :environment do

    Photo.find_each do |photo|
      unless photo.image_file_name.blank?
        partition = sprintf("%09d", photo.id).scan /\d{3}/
        parts = [
          'public',
          'system',
          'photos',
          'images',
          partition,
          'original',
          photo.image_file_name
          ].flatten

        filename = Rails.root.join(*parts)

        if File.exists? filename
          puts "Re-saving image attachment #{photo.id} - #{filename}"
          image = File.new filename
          photo.image = image
          photo.save
          # if there are multiple styles, you want to recreate them :
          photo.image.reprocess!
          image.close
        else
          puts "Couldn't find file: #{filename}"
        end
      end
    end
  end
end