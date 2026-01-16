class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :comments
  has_many :shares
  has_many :shared_posts, through: :shares, source: :post

  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :avatar_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
end
