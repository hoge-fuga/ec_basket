class User < ApplicationRecord
  before_save { self.email.downcase! }
  
  has_many :items
  validates :private, inclusion: {in: [true, false]}
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
                    
  has_secure_password
  
  def total_price
    return items.sum(:price)
  end
end