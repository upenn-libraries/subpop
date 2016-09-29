module FeatureMacros

  DEFAULT_FILE_PATH = "#{Rails.root}/spec/fixtures/images/BS_185_178207.jpg"

  def login_as username, attributes={}
    add_user username, attributes
    password = attributes[:password] || 'secretpassword'

    visit '/users/sign_in'
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  def add_user username, attributes={}
    User.find_by(username: username) or FactoryGirl.create(:user, attributes.merge(username: username))
  end

  def sign_out username
    click_link username
    click_link 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  def visit_evidence
    # we do the following to ensure the associations are loaded
    @evidence.inspect
    visit evidence_path(@evidence)
  end

  def visit_book
    @book ||= FactoryGirl.create :book
    @book.reload.photos
    visit book_path @book
  end

  def visit_new_bookplate
    # /books/1/evidence/new?utf8=%E2%9C%93&photo_id=1&book_id=1&use=bookplate_label&evidence%5Bphoto_id%5D=1&evidence%5Bbook_id%5D=1&evidence%5Bformat%5D=bookplate_label
    params = {
      photo_id: @photo.id,
      'evidence[photo_id]': @photo.id,
      'evidence[format]': 'bookplate_label',
      'evidence[book_id]': @book.id
    }
    visit new_book_evidence_path(@book, params)
  end

  def create_name_by username, attributes={}
    user                  = add_user username
    local_attrs           = attributes.dup
    local_attrs[:name]  ||= 'Smith, John'

    Name.new(attributes).save_by user
  end

  def create_book_with_photo_by username, attributes={}
    create_book_by username
    create_photo book: @book
  end

  def make_photo_a_title_page
    @title_page = FactoryGirl.create :title_page, book: @book, photo: @photo
  end

  def create_book_by username, attributes={}
    user                        = add_user username
    local_attrs                 = attributes.dup
    local_attrs[:title]       ||= 'A book title'
    local_attrs[:call_number] ||= 'BK 65431 .c'
    local_attrs[:repository]  ||= 'Big Old Library'

    @book = Book.new local_attrs
    @book.save_by user or raise_invalid_model @book
    @book
  end

  def create_photo attributes={}
    local_attrs               = attributes.dup
    local_attrs[:image]     ||= File.new(DEFAULT_FILE_PATH)
    local_attrs[:in_queue]  ||= true

    @photo = Photo.new local_attrs
    @photo.valid? or raise_invalid_model @photo
    @photo.save
    @photo
  end

  def create_context_image_by username, attributes={}
    user = add_user username
    local_attrs        = attributes.dup
    local_attrs[:book] = @book || create_book_by(username)
    unless local_attrs[:photo] || local_attrs[:photo_id]
      local_attrs[:photo] = (Photo.first || create_photo)
    end

    @context_image     = ContextImage.new local_attrs
    @context_image.save_by user or raise_invalid_model @context_image
    @context_image
  end

  def create_evidence_by username, attributes={}
    user        = add_user username
    local_attrs = attributes.dup

    local_attrs[:book]    ||= create_book_by username
    # we create the photo using the book
    local_attrs[:photo]   ||= create_photo book: local_attrs[:book]
    local_attrs[:format]  ||= 'binding'

    @evidence = Evidence.new local_attrs
    @evidence.save_by user or raise_invalid_model @evidence
    @evidence
  end

  def add_context_image_to_evidence_by username, evidence=nil
    context_image = ContextImage.first || create_context_image_by(username)
    @evidence.update_attributes! context_image: context_image
  end

  def raise_invalid_model obj
    raise "Invalid #{obj.model_name}: #{obj.errors.full_messages}"
  end
end