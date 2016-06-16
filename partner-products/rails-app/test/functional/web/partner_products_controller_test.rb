require 'test_helper'

class Web::PartnerProductsControllerTest < ActionController::TestCase
  setup do
  end

  # SHOW
  # should list partner products on type
  test 'should show partner product' do
    pp = create :partner_product
    get :show, id: pp
    assert_instance_of PartnerProduct, assigns(:partner_product)
    assert_equal pp.id, assigns(:partner_product).id, 'should assign partner product'
  end
end

