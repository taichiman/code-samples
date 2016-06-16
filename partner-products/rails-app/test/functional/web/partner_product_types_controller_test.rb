require 'test_helper'

class Web::PartnerProductTypesControllerTest < ActionController::TestCase

  # INDEX
  # list all active partner product types
  test "should list all active partner product type" do
    create_list :partner_product_type, 2
    create(:partner_product_type).mark_as_deleted!
    get :index
    assert_equal PartnerProductType.active.map(&:id).sort, assigns(:partner_product_types).map(&:id).sort
    assert_response :success
  end

  # SHOW
  # show one pptype
  test 'should compile a products for list for one pp_type' do
    2.times do
      partner1 = create :partner
      partner_product_type = create :partner_product_type
      create :partner_product, partner: partner1, partner_product_type: partner_product_type

      partner2 = create :partner
      create :partner_product, partner: partner2, partner_product_type: partner_product_type
    end

    pp_type = PartnerProductType.all.sample

    get :show, id: pp_type
    
    pp = PartnerProduct.where(partner_product_type_id: pp_type)
    
    assert_equal pp.map(&:id).sort, assigns(:partner_products).map(&:id).sort, 'should assigns products for pp_type'
    assert_equal pp_type.id, assigns(:pp_type).id, 'should assigns pp_type'
    assert_response :success
    assert_template :show
  end

  #TODO: create test for archived ppt
  test "should'nt show archived pp types" do
  end 

  #TODO: create test for ppt ordered view
  test "should show right order pp types" do
  end 
end

