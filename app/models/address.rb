class Address < ApplicationRecord
  belongs_to :user

  enum :address_type, {
    shipping: 0,
    billing: 1,
    other: 2
  }
end
