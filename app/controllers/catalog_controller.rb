#frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|
     ## Class for sending and receiving requests from a search index
    #config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    #config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    #config.response_model = Blacklight::Solr::Response

    # config.default_solr_params = {
    #   :qf => ['title_text', 'author_text'],
    #   :defType => 'edismax',
    #   :qt => 'search',
    #   :q => '*.*',
    #   rows: 10
    # }

    config.default_solr_params = {
      :qf => ['format_name_text',
        'location_name_without_page_text',
        'transcription_text',
        'book_title_text', 'book_author_text'],
      :defType => 'edismax',
      :qt => 'search',
      :q => '*:*',
      rows: 10
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  qt: 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # fl: '*',
    #  # rows: 1,
    #  # q: '{!term f=id v=$id}'
    #}

    # solr field configuration for search results/index views

    # config.index.title_field = 'title_display'
    # config.index.display_type_field = 'format'
    config.index.title_field = 'book_title'
    config.index.display_type_field = 'format'


    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)


  #Book facet field

    # config.add_facet_field 'title_ss', label: 'Title'
    # config.add_facet_field 'author_ss', label: 'Author'

    config.add_facet_field 'format_name_ss', label: 'Format'
    config.add_facet_field 'location_name_without_page_ss', label: 'Location in book'
    config.add_facet_field 'where_ss', label: 'Provenance Place'
    config.add_facet_field 'content_types_sms', label: 'Content Type'

    config.add_facet_field 'book_title_ss', label: 'Title'
    config.add_facet_field 'book_author_ss', label: 'Author'
    config.add_facet_field 'book_repository_ss', label: 'Current Repository'
    config.add_facet_field 'book_owner_ss', label: 'Current Owner'
    config.add_facet_field 'book_collection_ss', label: 'Current Collection'
    config.add_facet_field 'book_geo_location_ss', label: 'Current Location'
    config.add_facet_field 'book_creation_place_ss', label: 'Place of Publication/Creation'
    config.add_facet_field 'book_publisher_ss', label: 'Printer/Publisher/Scribe'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
  #Evidence index fields
    config.add_index_field 'format_name_ss', label: 'Format'
    config.add_index_field 'location_name_without_page_ss', label: 'Location in book'
    config.add_index_field 'format_other_ss', label: 'Other Format'
    config.add_index_field 'transcription_ss', label: 'Transcription'
    config.add_index_field 'date_narrative_ss', label: 'Date Narrative'
    config.add_index_field 'where_ss', label: 'Provenance Place'
    config.add_index_field 'comments_ss', label: 'Evidence Comments'
    config.add_index_field 'citation_ss', label: 'Citations'
    config.add_index_field 'content_types_sms', label: 'Content Type'

  #Book index fields
    config.add_index_field 'book_title_ss', label: 'Title'
    config.add_index_field 'book_author_ss', label: 'Author'
    config.add_index_field 'book_repository_ss', label: 'Repository'
    config.add_index_field 'book_owner_ss', label: 'Current Owner'
    config.add_index_field 'book_collection_ss', label: 'Current Collection'
    config.add_index_field 'book_geo_location_ss', label: 'Current Location'
    config.add_index_field 'book_call_number_ss', label: 'Call Number'
    config.add_index_field 'book_creation_place_ss', label: 'Place of Publication/Creation'
    config.add_index_field 'book_publisher_ss', label: 'Printer/Publisher/Scribe'
    config.add_index_field 'book_date_narrative_ss', label: 'Date Narrative'
    config.add_index_field 'book_acq_source_ss', label: 'Immediate Source of Acquisition'
    config.add_index_field 'book_comment_book_ss', label: 'Book Comments'


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display

  #Evidence show fields
    config.add_show_field 'format_name_ss', label: 'Format'
    config.add_show_field 'location_name_without_page_ss', label: 'Location in book'
    config.add_show_field 'format_other_ss', label: 'Other Format'
    config.add_show_field 'where_ss', label: 'Provenance Place'
    config.add_show_field 'content_types_sms', label: 'Content Type'


  #Book show field
    config.add_show_field 'book_title_ss', label: 'Title'
    config.add_show_field 'book_author_ss', label: 'Author'
    config.add_show_field 'book_repository_ss', label: 'Current Repository'
    config.add_show_field 'book_owner_ss', label: 'Current Owner'
    config.add_show_field 'book_collection_ss', label: 'Current Collection'
    config.add_show_field 'book_geo_location_ss', label: 'Current Location'
    config.add_show_field 'book_creation_place_ss', label: 'Place of Publication/Creation'
    config.add_show_field 'book_publisher_ss', label: 'Publisher'

   # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field 'all_fields', label: 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    # config.add_search_field('title') do |field|
    #   # solr_parameters hash are sent to Solr as ordinary url query params.
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

    #   # :solr_local_parameters will be sent using Solr LocalParams
    #   # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    #   # Solr parameter de-referencing like $title_qf.
    #   # See: http://wiki.apache.org/solr/LocalParams
    #   field.solr_local_parameters = {
    #     qf: '$title_qf',
    #     pf: '$title_pf'
    #   }
    # end

    # config.add_search_field('author') do |field|
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
    #   field.solr_local_parameters = {
    #     qf: '$author_qf',
    #     pf: '$author_pf'
    #   }
    # end



    config.add_search_field('format_name') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'format' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        qf: '$format_name_qf',
        pf: '$format_name_pf'
      }
    end

    config.add_search_field('transcription') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'transcription' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        qf: '$transcription_qf',
        pf: '$transcription_pf'
      }
    end

       config.add_search_field('book_author') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'author' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        qf: '$book_author_qf',
        pf: '$book_author_pf'
      }
    end

    config.add_search_field('book_title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'book_title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        qf: '$book_title_qf',
        pf: '$book_title_pf'
      }
    end

    config.add_search_field('book_repository') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'book_repository' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        qf: '$book_repository_qf',
        pf: '$book_repository_pf'
      }
    end
    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    #config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', label: 'relevance'
    #config.add_sort_field 'pub_date_sort desc, title_sort asc', label: 'year'
    #config.add_sort_field 'author_sort asc, title_sort asc', label: 'author'
    #config.add_sort_field 'title_sort asc,' label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'


  end
end
