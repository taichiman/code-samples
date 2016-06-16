require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  def test_should_require_name_ru
    partner = build :partner, name_ru: ''
    partner.valid?
    assert partner.errors.has_key?(:name_ru), 'Validation error'

  end
end
