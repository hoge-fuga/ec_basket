class Item < ApplicationRecord
  belongs_to :user
  
  validates :url, allow_blank: true, length: { maximum: 2000 },
                  format:  /\A#{URI::regexp(%w(http https))}\z/  
  validates :name, presence: true, length: { maximum: 255 }
  validates :price, allow_blank: true, numericality: :only_integer
  validates :image_url, allow_blank: true, length: { maximum: 50000 },
                  format:  /\A(#{URI::regexp(%w(http https))}|data:image\/(jpg|jpeg|gif|png|bmp);base64,\s?[\w\/+=]+)\z/
end