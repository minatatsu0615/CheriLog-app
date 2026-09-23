class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum :emotion, {
    happy: 0,
    excited: 1,
    cozy: 2,
    calm: 3,
    love: 4,
    wow: 5,
    inspired: 6,
    touched: 7,
    grateful: 8,
    curious: 9
  }

  validates :favorite_rating,
            inclusion: { in: 1..5 },
            allow_nil: true
end
