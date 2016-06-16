require 'test_helper'

class Api::PartnersControllerTest < ActionController::TestCase
  setup do
    user = create :user
    sign_in user

    partners = create_list(:partner, 5)
    @ids = partners.map(&:id)
  end

  def test_reorder_partners_order
    new_order = @ids.reverse
    put :mass_update_order_at, ids: new_order
    assert_response :success
    partners = Partner.asc_by_order_at
    assert_equal new_order, partners.map(&:id)
  end
end

