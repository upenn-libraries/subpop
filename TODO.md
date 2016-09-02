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

# Image editing


# cropping

- fit image in container

- Decide whether a used master image can be edited and how to behave if yes

    - Option 1) If the image has been used for evidence or a title page, create
      a new photo object to assign to each publishable to which the image is
      attached

    - Option 2) If the image has been used for evidence or a title page, create
      a new *master* photo and edit it.

    - Option 3) Locking: Lock the master image if it has been used.

    - Option 3a) Modified locking:  Lock master image, but allow it to be
      duplicated (this is about the same thing as Option 2).

- set cropped modal max size to window size?
- upload image to app
- create/update image
- create context image
- when updating photo show progress bar for image in status element



## Flickr

- make sure flickrize_tags calculates correct tags for existing photos

## Unordered list of stuff

### General

Docker

  - data volume for database
  - logs

SubPopFormbuilder: hints don't work for nest form objects

Add exception notification

Rename HasPhoto to BelongsToPhoto; it's confusing as it's named now.

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
