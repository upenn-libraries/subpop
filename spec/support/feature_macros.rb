module FeatureMacros

  DEFAULT_FILE_PATH = "#{Rails.root}/spec/fixtures/images/BS_185_178207.jpg"

  def login_as username, attributes={}
    user = add_user username, attributes
    password = attributes[:password] || 'secretpassword'

    visit '/users/sign_in'
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  def add_user username, attributes={}
    User.find_by username: username or FactoryGirl.create :user, attributes.merge(username: username)
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
    visit book_path @book
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
    local_attrs           =   attributes.dup
    local_attrs[:image] ||= File.new(DEFAULT_FILE_PATH)

    @photo = Photo.new local_attrs
    @photo.valid? or raise_invalid_model @photo
    Photo.create! local_attrs
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

  def raise_invalid_model obj
    raise "Invalid #{obj.model_name}: #{obj.errors.full_messages}"
  end
end