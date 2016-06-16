class PartnerProductType < ActiveRecord::Base
  include PartnerProductTypeRepository

  attr_accessible :title_ru, :subtitle_ru, :description_ru, :picture, :order_at

  validates :title_ru, presence: true, length: {maximum: 255}

  has_many :partner_products

  state_machine initial: :active do
    before_transition any => :deleted do |obj, transition|
      obj.deleted_at = Time.current
    end
    before_transition :deleted => any do |obj, transition|
      obj.deleted_at = nil
    end
    state :active
    state :deleted

    event :restore do
      transition :deleted => :active  
    end

    event :mark_as_deleted do
      transition :active => :deleted
    end
  end

  mount_uploader :picture, PartnerProductTypePictureUploader 
end

