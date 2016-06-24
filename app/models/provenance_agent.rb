class ProvenanceAgent < ActiveRecord::Base
  belongs_to :evidence, required: true, inverse_of: :provenance_agents
  belongs_to :name, required: true, counter_cache: true

  delegate :full_name, to: :name, prefix: false, allow_nil: true
  delegate :book, to: :evidence, allow_nil: true

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

  def role_name
    return if role.blank?

    ROLES_BY_CODE[role]
  end
end
