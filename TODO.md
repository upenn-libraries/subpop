# To-do items

## Scratch

Add sidebar prompt to choose title page images

### General

Docker

  - data volume for database
  - logs
  - test log options
<!--   - fix `.dockerignore` -- stop copying log files into container
    + figure out why `delayed_job.log` alone isn't ignored -->

  - backup plan for database

  - talk to OEM about setting up production box -- with space allocation for images

Set up permanent servers:

- Production

- Administration of workflow for "probation" users

Migrate current spreadsheets to app

Spreadsheet import: Deal with single images for multiple pieces of provenance

Add Blacklight to application

#### All sections:


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

<!-- Edit/New pages
- "Back to photo queue" anchor on Safari doesn't scroll down far enough -->

<!-- Create context images -->

<!-- Investigate image cropping -->

<!-- Evidence show page:

- Add name window from Add name list -->

Evidence form:

- Provenance agents hide/delete button instead of checkbox

Provenance agents:
- When selecting name and user hits enter, prevent form submission

<!-- Where?

  - ?? Provenance place?
  - Hint? <-- Try this one. "Give a place named in the provenance mark or the location of the book at the time the mark was added." -->

<!-- X - fit image in container

x - Decide whether a used master image can be edited and how to behave if yes
x
x     - Option 1) If the image has been used for evidence or a title page, create
x       a new photo object to assign to each publishable to which the image is
x       attached
x
x     - Option 2) If the image has been used for evidence or a title page, create
x       a new *master* photo and edit it.
x
x     - Option 3) Locking: Lock the master image if it has been used.
x
x     - Option 3a) Modified locking:  Lock master image, but allow it to be
x       duplicated (this is about the same thing as Option 2).
x
x - set cropped modal max size to window size?
x - upload image to app
x - create/update image
x - when updating photo show progress bar for image in status element -->
<!-- x - Rename concern HasPhoto -> BelongsToPhoto -->
<!-- Automatically display context image created for cropped photos -->
<!-- Do not attach context image on crop if one is already assigned -->
<!-- Delete action for publishables removes 'Delete' button from all publishables -->
<!-- User model: exclude certain user names: 'all', 'admin', etc. -->
<!-- Add exception notification -->
<!-- - create context image -->
<!-- ## Flickr

- make sure flickrize_tags calculates correct tags for existing photos

## Unordered list of stuff -->
 <!-- Rename HasPhoto to BelongsToPhoto; it's confusing as it's named now. -->
<!-- + stop copying `doc/api` -->
<!-- SubPopFormbuilder: hints don't work for nest form objects -->
<!-- User support: -->
<!-- - Add full_name to user -->
<!-- - Add user to books and evidence: `created_by`, `updated_by` -->
<!-- - Show user's books -->
<!-- - Push to Flickr workflow -->
<!-- Clean up pages; improve layout -->
<!-- Model name: -->
<!-- - replace `item.class.name.underscore` with `item.model_name.element`
  throughout -->