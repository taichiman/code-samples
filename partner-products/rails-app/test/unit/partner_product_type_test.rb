require 'test_helper'

class PartnerProductTypeTest < ActiveSupport::TestCase
  def test_should_require_title_ru
    partner_product_type = build :partner_product_type, title_ru: ''
    partner_product_type.valid?
    assert partner_product_type.errors.has_key?(:title_ru), 'Validation error'
  end
end

