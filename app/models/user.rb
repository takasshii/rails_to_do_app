class User < ApplicationRecord
  has_secure_password
  include Hashid::Rails
  validates :name, { presence: true }
  validates :email, { presence: true, uniqueness: true }
  has_many :posts
  has_many :likes
  # validates :password, {presence: true}

  def posts
    return Post.where(user_id: self.id)
  end
end
