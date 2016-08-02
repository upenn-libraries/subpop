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

# Image edit behavior

### Edit master image

- User selects 'Edit master image' from Photo queue
- System displays Image edit page
- User makes edits
- User clicks "Save"
- System saves original image and updates derivs


##### Edit image for title page or evidence

- User selects image for evidence (e.g., Bookplate)
- System displays modal with image and query: 'Edit image?'
- User clicks 'Edit image'
- System displays Image edit page
- User makes edits
- Image edit page has:
    - 'Use original as context image' checkbox, default: checked
    - Buttons: 'Cancel', 'Save'
- See below for Cancel/Save behaviors:
    - 'Save' with 'Context image' checked
    - 'Save' with 'Context image' unchecked
    - 'Cancel'

#### User clicks 'Save' with 'Context image' checked

- User edits image
- User clicks 'Save' with 'Context image' checked
- System creates Context Image and attaches original Photo
    + Note there's a risk here, we can't guarantee the original photo won't be
      edited in such a way it is no longer usable for context image.
- System creates new evidence Photo object with cropped content
- System attaches new evidence Photo to evidence
- System displays New Evidence page with new image
- User fills in information, etc.

#### User clicks 'Save' with 'Context image' unchecked

- User edits image
- User clicks 'Save' with 'Context image' checked
- System creates new evidence Photo object with cropped content
    + It seems we always have to do this. We don't know that user doesn't want
      to use the original image again.
- System attaches new evidence Photo to evidence
- System displays New Evidence page with new image
- User fills in information, etc.

#### User clicks 'Cancel' scenario 1

- User edits images or not
- User clicks 'Cancel' on edit image page
- System continues to edit Evidence page

If user wants to Cancel evidence creation, user must click cancel again.  We
can't know what the user wants to cancel: photo editing or evidence creation.

#### User clicks 'Cancel' scenario 2

- User edits images or not
- User clicks 'Cancel' on edit image page
- System returns user to image queue on book page

If user wants to Cancel only image creation, too bad. We return the user to the
queue to start over. At that point, the user should select not to edit the
image.

#### Cancel scenario 3

- System displays two cancel buttons 'Cancel save; create Bookplate' and 'Cancel bookplate'.
- User clicks selection
- System continues to new evidence page or returns to photo queue based on
  user's choice.


### Possible problems

User creates context image by mistake; need to be able to delete context image

User doesn't like context image; wants to edit it

User wants to attach different image attached to evidence

User wants to edit image attached to evidence/context image/title page


## Flickr

## Unordered list of stuff

### General

Docker

  - data volume for database
  - logs

Add exception notification

Set up permanent servers:

<!-- - Staging -->
- Production

Double check fields:

- Books
- Evidence

User support:

<!-- - Add full_name to user -->
<!-- - Add user to books and evidence: `created_by`, `updated_by` -->
- Show user's books
<!-- - Push to Flickr workflow -->
- Administration of workflow for "probation" users

Migrate current spreadsheets to app

Spreadsheet import: Deal with single images for multiple pieces of provenance

Add Blacklight to application

<!-- Model name: -->

<!-- - replace `item.class.name.underscore` with `item.model_name.element`
  throughout -->

#### All sections:

Clean up pages; improve layout

Manage position of side image, when resizing to smaller page layout

  - TODO Make image both fixed and responsive, from CSS comments:

        // TOOD: Placeholder for the evidence image div, so we can make it fixed
        // later. It's hard with bootstrap to fix the image *and* have it be
        // responsive to window resizing. If fixed, the text floats over and
        // covers the fixed image upon resizing.

#### Flickr ####

<!-- Move flickr_preview partial from shared to flickr/show view -->

#### Books ####

<!-- Add date_narrative field
  - form
  - show
  - hint
 -->
#### Evidence

Edit/New pages
- "Back to photo queue" anchor on Safari doesn't scroll down far enough

Create context images

Investigate image cropping

Evidence show page:

- Add name window from Add name list

Evidence form:

- Provenance agents hide/delete button instead of checkbox

Provenance agents:
- When selecting name and user hits enter, prevent form submission

<!-- Where?

  - ?? Provenance place?
  - Hint? <-- Try this one. "Give a place named in the provenance mark or the location of the book at the time the mark was added." -->
