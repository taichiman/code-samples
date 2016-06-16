require 'test_helper'

class PartnerProductItemTest < ActiveSupport::TestCase
  def test_should_require_title_ru
    ppi = build :partner_product_item, title_ru: ''
    ppi.valid?
    assert ppi.errors.has_key?(:title_ru), 'Validation error when title_ru is blank'
  end
end

