class PartnerProductItem < ActiveRecord::Base
  include Archify
  include PartnerProductItemRepository

  attr_accessible :title_ru, :tizer_ru, :description_ru, :image

  belongs_to :partner_product
  
  validates :title_ru, presence: true

  mount_uploader :image, PartnerProductItemImageUploader

end

