class Item < ApplicationRecord
  belongs_to :user
  
  validates :url, presence: true, length: { maximum: 2000 },
                  format:  /\A#{URI::regexp(%w(http https))}\z/  
  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: :only_integer
  validates :image_url, presence: true, length: { maximum: 2000 },
                        format:  /\A#{URI::regexp(%w(http https))}\z/
end