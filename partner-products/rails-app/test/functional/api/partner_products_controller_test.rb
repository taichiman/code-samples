require 'test_helper'

class Api::PartnerProductsControllerTest < ActionController::TestCase
  setup do
    user = create :user
    sign_in user

    partner_products = create_list(:partner_product, 5)
    @ids = partner_products.map(&:id)
  end

  def test_reorder_partner_products_order
    new_order = @ids.reverse
    put :mass_update_order_at, ids: new_order
    assert_response :success 
    partner_products = PartnerProduct.asc_by_order_at
    assert_equal new_order, partner_products.map(&:id)
  end

end

