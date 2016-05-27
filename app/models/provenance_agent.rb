class ProvenanceAgent < ActiveRecord::Base
  belongs_to :evidence, required: true, inverse_of: :provenance_agents
  belongs_to :name, required: true, counter_cache: true

  delegate :full_name, to: :name, prefix: false, allow_nil: true

  ROLES = [
    [ "Owner",                        "owner"      ],
    [ "Binder",                       "binder"     ],
    [ "Annotator",                    "annotator"  ],
    [ "Bookseller/Auction House",     "bookseller" ],
    [ "Librarian",                    "librarian"  ],
    [ "Unknown role",                 "unknown"    ],
  ]

  ROLES_BY_CODE = ROLES.inject({}) { |hash, pair|
    hash.merge(pair.last => pair.first)
  }

  validates :role, inclusion: ROLES.map(&:last)

  class << self
    def role_name code
      ROLES_BY_CODE[code]
    end
  end
end
