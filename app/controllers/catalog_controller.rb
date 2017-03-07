#frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|

    config.add_facet_field 'title', label: 'Title'

    config.add_index_field 'title', label: 'Title'

    config.add_show_field 'title', label: 'Title'
  end
end
