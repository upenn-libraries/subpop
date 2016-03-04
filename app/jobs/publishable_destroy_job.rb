class PublishableDestroyJob
  def destroy klass, id
    publishable = klass.find id
    publishable.destroy
  end

  handle_asynchronously :destroy
end