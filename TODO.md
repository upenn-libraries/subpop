# To-do items

### For discussion

- Dates associated with names
    + We want LC-style name entries, but we also want to have separate dates;
      this is contradictory. How do we proceed? What about legacy data -- how
      are those names formatted?

- Format Other, and Other format field
    + This has been added, but it is almost certainly bad. Users will likely
      reject our categories and create their own, resulting in, for example,
      variations on stamp and bookplate that are arbitrary and unsearchable.

### Work plan

Name search autocomplete: prevent dates' appearing in search field on select

Pushing to Flickr:
 - Spinner while publishing

### Unordered list of stuff

- image upload spinner

Set up permanent servers:
- Staging
- Production

Fix title page sidebar to show more than one image

Clean up pages; improve layout

Double check fields:

- Books
- Evidence

Create context images

Add ability to remove images from queue when done

Investigate image cropping

Show progress bar/spinner for images being created

Evidence show page:

- Add name window from Add name list

User support:
    - Login
    - Add use to books and evidence: `created_by`, `updated_by`
    - Show user's books
    - Push to Flickr workflow
    - Administration of users
    - Administration of workflow for "probation" users

Migrate current spreadsheets to app

Add Blacklight to application

Deal with single images for multiple pieces of provenance

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

X Table evidence, remove columns:
X - content_type

X Validations:
X - ContentType validattions - require name, - name unique
X- Evidence
X  - format
X  - location in book
X - Book - ?
X- Name
X  - require name
X  - name is unique unique
X - Add citation
X Names:
X - Copy "Create name" to top of index page
X - Ability to remove image from Flickr
X Add hints to fields:
X - New name -- preferred name format
x Show names -- show dates too when available
X  - Handle menu changes
X Add exception to names#detroy to prevent deletion used names
