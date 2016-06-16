class PartnerProduct < ActiveRecord::Base
  include PartnerRepository

  attr_accessible :title_ru, :subtitle_ru, :description_ru, :partner_id, :partner_product_type_id

  belongs_to :partner
  belongs_to :partner_product_type
  has_many   :partner_product_items
  
  validates :title_ru, presence: true
  validates :partner_id, presence: true
  validates :partner_product_type_id, presence: true

  state_machine initial: :active do
    before_transition any => :deleted do |obj, transition|
      obj.deleted_at = Time.current
      obj.order_at = 0
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

end
