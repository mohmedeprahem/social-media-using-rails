class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true, length: { minimum: 3 }

  validates :author, presence: true
  validate :must_have_tags

  def must_have_tags
    errors.add(:tag_ids, "must be present") if tag_ids.blank?
  end
end
