#encoding: utf-8
require 'test_helper'

# TODO: ref index to only :active 

class Web::Admin::PartnerProductTypesControllerTest < ActionController::TestCase
  setup do
    user = create :user
    sign_in user

    @pp_type_attrs = attributes_for :partner_product_type
    @pp_type = create :partner_product_type
  end

  # NEW
  test "should show a form for new pp_type" do
    get :new
    assert_not_nil assigns(:pp_type), '@pp_type should\'nt be nil'
    assert_response :success
    assert_template :new
  end

  # CREATE
  test "should create valid pp_type" do
    assert_difference('PartnerProductType.count', 1, 'new pp_type has created') do
      post :create, partner_product_type: @pp_type_attrs
    end
    assert_response :found
    assert_redirected_to admin_partner_product_types_path 
    assert_equal flash[:notice], 'Тип успешно создан'
  end 

  test "should\'nt create invalid pp_type" do
    post :create, @pp_type_attrs.merge(title_ru: '')
    assert_template :new
    assert_response :success
  end 

  # INDEX
  test "should list all active pp_types" do
    PartnerProductType.delete_all
    pp_types = create_list :partner_product_type, 4
    pp_types_deleted = PartnerProductType.limit(2)
    pp_types_deleted.each { |i| i.mark_as_deleted! }
    pp_types_active = PartnerProductType.active

    get :index
    assert_equal pp_types_active.map(&:id), assigns(:pp_types).map(&:id).sort
    assert_template :index
  end

  test 'should output with right order' do
    PartnerProductType.delete_all
    2.downto(0) { |i| create :partner_product_type, order_at: i } 
    get :index
    assert_equal [0,1,2], assigns(:pp_types).map(&:order_at), 'the pp_type order should be ascendant'
  end

  # EDIT
  test "should edit pp_type" do
    get :edit, id: @pp_type
    assert_template :edit
  end

  # UPDATE
  test "should update pp_type with valid data" do
    new_title = @pp_type[:title_ru].reverse

    assert_difference('(@pp_type.reload.title_ru.hash == new_title.hash) ? 1 : 0') do
      post :update, id: @pp_type, partner_product_type: {title_ru: new_title}
    end 
    assert_redirected_to admin_partner_product_types_path
    assert_response :found
     
  end

  test "should\'nt update pp_type with invalid title" do
    assert_difference('@pp_type.reload.title_ru.hash', 0, 
                      'should break validation') { 
      post :update, id: @pp_type, partner_product_type: {title_ru: ''}
    }
    assert_template :edit
  end

  # Archive and restore items
    # ARCHIVE
    test "should archive pp_type" do
      put :destroy, id: @pp_type
      assert_equal 'deleted', @pp_type.reload.state
      assert_redirected_to admin_partner_product_types_path
    end

    # DELETED
    # list deleted items
    test "should list of deleted pp_types" do
      create_list :partner_product_type, 2

      pp_types_deleted = create_list :partner_product_type, 2
      pp_types_deleted.each { |i| i.mark_as_deleted! }

      get :deleted
      assert_template :deleted
      assert_equal pp_types_deleted.map(&:id), assigns(:pp_types).map(&:id).sort
    end

    # RESTORE
    test "should restore the pp_type" do
      @pp_type.mark_as_deleted!
      assert @pp_type.reload.state == 'deleted'

      put :restore, id: @pp_type
      assert_equal 'active', @pp_type.reload.state
      assert_redirected_to admin_partner_product_types_path
    end
end

