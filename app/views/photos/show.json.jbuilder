json.merge! @photo.attributes
# add `processing` to work with general poll_process function
json.processing @photo.image_processing
