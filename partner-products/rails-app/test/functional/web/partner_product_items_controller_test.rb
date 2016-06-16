require 'test_helper'

class Web::PartnerProductItemsControllerTest < ActionController::TestCase
  # SHOW
  # should show an item type
  test 'should show partner product item' do
    ppi = create :partner_product_item
    get :show, id: ppi
    assert_instance_of PartnerProductItem, assigns(:item)
    assert_equal ppi.id, assigns(:item).id, 'should assign the item'
  end
end

