class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :shares, dependent: :destroy

  def shared_by?(user)
    shares.exists?(user: user)
  end

  scope :filter_by_tag, ->(tag_name) { 
    joins(:tags).where(tags: { name: tag_name }) 
  }

  scope :search_by_keyword, ->(query) {
    where("posts.title LIKE :q OR posts.body LIKE :q", q: "%#{query}%")
  }

  def self.search(query)
    return all if query.blank?

    if query.strip.start_with?("#")
      tag_name = query.strip[1..-1]
      filter_by_tag(tag_name)
    else
      search_by_keyword(query)
    end
  end
end
