class ProvenanceAgent < ActiveRecord::Base
  belongs_to :evidence
  belongs_to :name

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

  class << self
    def role_name code
      ROLES_BY_CODE[code]
    end
  end
end
