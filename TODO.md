# To-do items


### Work plan

Pushing to Flickr:
 - Ability to remove image from Flickr
 - Spinner while publishing

### Unordered list of stuff

Table evidence, remove columns:
- content_type

- image upload spinner

Validations:
- ContentType - require name
- unique
- Evidence - ?
- Book - ?
- Name - require name
- unique

Set up permanent servers:
- Staging
- Production

Clean up pages; improve layout

- Add citation

Names:
- Copy "Create name" to top of index page

Double check fields:

- Books
- Evidence

Add hints to fields:
- New name -- preferred name format

Create context images

Show names -- show dates too when available

Add ability to remove images from queue when done

Investigate image cropping

Show progress bar/spinner for images being created

Evidence show page:

- Add name window from Add name list

User support:
    - Login
    - Show user's books
    - Push to Flickr workflow
    - Administration of users
    - Administration of workflow for "probation" users

Migrate current spreadsheets to app

# DONE

X Evidence:
X - Show page: only show location_in_book_page if location_in_book is 'page_number'
X - Add format_other; for when user selects "other" format type
X - Have `location_in_book_page` show up when user selects page number for
location

X - Toggling format_other; delete format_other content when field toggled off? or have value deleted on save? This last will allow user to toggle field other on/off before submit without removing data

X - Toggling location_in_book_page; delete content whenever field toggled off? or have value deleted on save? This last will allow user to toggle field on/off before submit without removing data

 X - Subsequent publishing
 X - doesn't create new Flickr image
 X  - Add published_at to Evidence
 X - Online republish if changed
 X - Collect and publish metadata
 X - Display Flickr URL

X - image_file_name
X - image_content_type
X - image_file_size
X - image_updated_at
Provenance Roles:
X - Add role 'Unknown'
Table title_page, remove columns:
X - image_file_name
X - image_content_type
X - image_file_size
X - image_updated_at

X Book:
X - Copy edit button to top of show page
