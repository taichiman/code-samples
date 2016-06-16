require 'test_helper'

class Api::PartnerProductTypesControllerTest < ActionController::TestCase
  setup do
    user = create :user
    sign_in user

    partner_product_types = create_list(:partner_product_type, 5)
    @ids = partner_product_types.map(&:id)
  end

  def test_reorder_partner_product_types_order
    new_order = @ids.reverse
    put :mass_update_order_at, ids: new_order
    assert_response :success 
    partner_product_types = PartnerProductType.asc_by_order_at
    assert_equal new_order, partner_product_types.map(&:id)
  end

end

