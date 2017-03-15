#frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|
        config.default_solr_params = {
      :qf => 'title_text',
      :defType => 'edismax',
      :qt => 'search',
      :rows => 10
}

    config.add_facet_field 'title', label: 'Title'

    config.add_index_field 'title_ss', label: 'Title'

    config.add_show_field 'title', label: 'Title'

    config.add_search_field 'all_fields', label: 'All Fields'
  end
end
