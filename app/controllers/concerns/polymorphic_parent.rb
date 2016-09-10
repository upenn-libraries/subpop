# Photos can have several types of Photo "parents" (usually not really a
# parent; see below). This module examines the params hash for parent ID types
# -- `book_id`, `evidence_id`, etc. It has methods for setting the parent to
# `@parent`; getting the class of the parent, its model name, and finding the
# parent based on its id.
#
# On the `lie` of the parent metaphor
# ===================================
#
# Publishables, that is, Evidence, TitlePage, and ContextImage, are not in
# fact parents of photos. While a photo `belongs_to` a book and, thus, a book
# is a photo's parent, a publishable `belongs_to` a photo and, thus, the photo
# is the publishable's parent.
#
# Nevertheless, I use the convention of parent as a convenience here. This
# allows us to have nested routes and have single actions that work with
# either a Book, Evidence, TitlePage, or ContextImage. For Ajax calls that
# load partials during image processing and for image cropping, we need a way
# to pass round the photo ID and the ID of the associated object. This
# information is used by controllers to update associations and then redirect
# to actions that display forms and partials with the correct associations.
# The information is also used by JavaScript methods to locate divs to replace
# based on photo and associations IDs. This is illustrated by the following
# routes for editing a photo associated with particular association model:
#
#              cropping_book_photo PATCH  /cropping/books/:book_id/photos/:id(.:format)                   cropping/photos#update
#          cropping_evidence_photo PATCH  /cropping/evidence/:evidence_id/photos/:id(.:format)            cropping/photos#update
#        cropping_title_page_photo PATCH  /cropping/title_pages/:title_page_id/photos/:id(.:format)       cropping/photos#update
#     cropping_context_image_photo PATCH  /cropping/context_images/:context_image_id/photos/:id(.:format) cropping/photos#update
#
# When any of these actions is invoked the system begins processing the
# updated image and browser is redirected to the `thumbnails#show` action for
# that 'parent' and photo. The action returns JavaScript that locates the
# `div` or `div`'s to load the new thumbnail partial into based on the photo
# ID and associated 'parent'. The ThumbnailsController likewise takes
# advantage of nested resources for this purpose:
#
#              book_thumbnail GET    /books/:book_id/thumbnails/:id(.:format)                             thumbnails#show
#        title_page_thumbnail GET    /title_pages/:title_page_id/thumbnails/:id(.:format)                 thumbnails#show
#          evidence_thumbnail GET    /evidence/:evidence_id/thumbnails/:id(.:format)                      thumbnails#show
#     context_image_thumbnail GET    /context_images/:context_image_id/thumbnails/:id(.:format)           thumbnails#show
#
# The method relies on to div classes `.thumb-container` and `.thumb`. Here's an example:
#
#     <div class="thumb-container" id="ui-id-1">
#       <div class="thumb" data-parent="10" data-parent-type="evidence" data-thumbnail="174">
#         <a target="_blank" data-toggle="tooltip" rel="noopener noreferrer" title="Click to open in new window."
#           href="/system/photos/images/000/000/174/original/BS_185_178207.jpg?1473367360">
#           <img class="img-responsive center-block" src="/system/photos/images/000/000/174/small/BS_185_178207.jpg?1473367360"
#             alt="Bs 185 178207" />
#         </a>
#       </div>
#     </div>
#
# Note the `data-parent-type`, `data-parent`, and `data-thumbnail`  atrributes
# which contain the parent type, parent ID, and photo ID, respectively, and
# are used to locate the `div.thumb` and it's parent `div.thumb-container`.
#
# Note that we cannot simply rely on the photo ID because in some case more
# than one parent may be associated with the same photo. This happens when a
# photo is first assigned to a publishable, like a TitlePage. In this case the
# same photo ID is assigned to book and to the title page. Thumbnails for both
# are displayed on the books#show page. In fact, the TitlePage thubmnail
# appears twice: once in the sidebar and once in the list of image statuses,
# meaning that before editing the same image thumbnail appears three times on
# the page. When the user chooses to edit the title page photo, a new photo is
# created for the title page, but not for the book. We have to redisplay the
# image for each of the two title page thumbnails, but not for the book. Also,
# the new photo has a new ID; thus, we need to find the `div.thumb` based on
# the ID of the original photo (`source_photo_id` parameter).
#
# TODO?
# =====
#
# The purer way to do this would, perhaps, be to have something like a
# PhotoAssignment\* model that connects a photo to a Book or Publishable
# (asterisk to indicate the model doesn't yet exist). The PhotoAssignment
# would have a `belongs_to` association with the parent. A Book object would
# `have_many` PhotoAssignment\*, while each Publishable object would
# `have_one` PhotoAssignment\*.
#
# It requires further investigation to determine whether the PhotoAssignment\*
# model would work. Presumably the association would be polymorphic, books and
# publishables being treated as `:assignable` or similar, with PhotoAssignment\*
# having
#
# ```ruby
#     belongs_to :assignable, polymorphic: true
# ```
#
# See the Rails guides for more on [polymorphic associations][rails-poly].
#
# [rails-poly]: http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
#
# This method, using the PhotoAssignment\* has many potential benefits. One of
# these would be to reduce the complexity of locating the div to replace. We
# would replace the div based on the ID of the assignment, not the photo. When
# a photo edit results in a new photo (see below), a new assignment would
# **not** be created; rather, the assignment would be updated to point to the
# new photo. All this means that the `div.thumb` from above can be changed to:
#
#     <div class="thumb-container" id="ui-id-1">
#       <!-- OLD VERSION: <div class="thumb" data-parent="10" data-parent-type="evidence" data-thumbnail="174"> -->
#       <div class="thumb" data-photo-assignment="10">
#         <!-- ... etc. ... -->
#         </a>
#       </div>
#     </div>
#
# Another advantage of the PhotoAssignment\* model is simplifying the
# controller processes. At present, the cropping `POST`/`#create` actions
# require a new assignment. The assignment happens differently for books and
# publishables owing to the different types of association. For the
# PhotoAssignment\* model the associations would be closer, though not the
# same. Note:
#
# ```ruby
# # Books have many photos
# class Book
#   has_many :photo_assignments, as: :assignable
# end
#
# # Wherease publishables, like Evidence have one photo
# class Evidence
#   has_one :photo_assignment, as: :assignable
# end
# ```
#
# __IMPORTANT__: It remains to be seen whether this `has_one`/`has_many`
# combination will work with the same polymorphic association.
#
# Creating a new photo
# --------------------
#
# When is a new photo created? If a user wants to edit a photo that belongs to
# both a book and some publishable, we create a new photo that is then
# associated with the  selected parent (book or publishable).
#
module PolymorphicParent
  extend ActiveSupport::Concern

  PARENT_ID_TYPES = %w{
    book_id evidence_id title_page_id context_image_id
  }.map &:to_sym

  def set_parent
    @parent = find_parent
  end

  def set_or_create_parent
    @parent = find_or_create_parent
  end

  def set_parent_type
    @parent_type = params[:parent_type]
  end

  def parent_model
    return parent_id_param.to_s.chomp '_id'  if parent_id_param.present?
    return                                   if params[:parent_type].blank?
    params[:parent_type].singularize
  end

  def parent_id_param
    # Return the first param name that matches the param hash.
    PARENT_ID_TYPES.find { |p| params[p] }
  end

  def parent_class
    return unless parent_model.present?
    parent_model.classify.safe_constantize
  end

  def parent_id
    return if parent_id_param.blank?
    params[parent_id_param]
  end

  def find_parent
    return if parent_id.blank?

    parent_class.find parent_id
  end

  ##
  # Always return a parent if at all possible: either the specific parent
  # instance or a new instance. If there's no parent ID or `parent_type`
  # available, return `nil`.
  def find_or_create_parent
    return                  if parent_class.blank?
    return parent_class.new if parent_id.blank? || parent_id == 'new'

    parent_class.find parent_id
  end
end