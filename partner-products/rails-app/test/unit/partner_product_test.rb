require 'test_helper'

class PartnerProductTest < ActiveSupport::TestCase
  def test_should_require_title_ru
    partner_product = build :partner_product, title_ru: ''
    partner_product.valid?
    assert partner_product.errors.has_key?(:title_ru), 'Validation error'
  end

  def test_should_require_partner
    partner_product = build :partner_product, partner_id: ''
    partner_product.valid?
    assert partner_product.errors.has_key?(:partner_id), 'Validation error'
  end

  def test_should_require_partner_product_type
    partner_product = build :partner_product, partner_product_type_id: ''
    partner_product.valid?
    assert partner_product.errors.has_key?(:partner_product_type_id), 'Validation error'
  end
end
