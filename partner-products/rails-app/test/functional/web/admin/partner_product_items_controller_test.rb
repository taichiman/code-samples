#encoding: utf-8
require 'test_helper'

class Web::Admin::PartnerProductItemsControllerTest < ActionController::TestCase
  setup do
    sign_in create(:user)

  end
  
  # NEW
  # create view for item
  test '#new' do
    pp = create :partner_product

    get :new, partner_product_id: pp.id
    assert_template 'new'
  end

  # CREATE
  test "should\'nt create invalid pp_type" do
    pp = create :partner_product
    ppi = attributes_for :partner_product_item, title_ru: ''

    assert_no_difference 'PartnerProductItem.count', 'should\'nt create Item record' do
      post :create, partner_product_id: pp, partner_product_item: ppi
    end
    assert_template :new
    assert_response :success
  end 

  test "should create valid PartnerProductItem" do
    pp = create :partner_product
    ppi = attributes_for :partner_product_item

    assert_difference('PartnerProductItem.count', 1, 'new pp_item has\'nt created') do
      post :create, partner_product_id: pp, partner_product_item: ppi
    end
    assert_response :found
    assert_redirected_to admin_partner_product_partner_product_items_path(pp)
    assert_equal flash[:notice], 'Товар партнера успешно создан'
  end 

  # INDEX
  # show all items for partner product
  test "should list all active partner product items" do
    PartnerProductItem.delete_all
    pp = create :partner_product
    ppi = create_list :partner_product_item, 4, partner_product_id: pp.id
    ppi_deleted = PartnerProductItem.limit(2)
    ppi_deleted.each { |i| i.mark_as_deleted! }
    ppi_active = PartnerProductItem.active

    get :index, partner_product_id: pp
    assert_equal ppi_active.map(&:id), assigns(:ppis).map(&:id).sort
    assert_template :index
  end

  # EDIT
  # edit the item
  test 'should shows item edit view' do
    ppi = create :partner_product_item
    get :edit, id: ppi
    assert_template :edit
    assert_equal assigns(:ppi).id, ppi.id
  end

  # UPDATE
  # update item

  test "should\'nt update item with invalid title" do
    ppi = create :partner_product_item
    assert_difference('ppi.reload.title_ru.hash', 0, 
                      'validation error when title is blank') { 
      post :update, partner_product_id: ppi.partner_product, id: ppi, partner_product_item: {title_ru: ''}
    }
    assert_template :edit
  end

  test "should update item with valid data" do
    ppi = create :partner_product_item
    pp = ppi.partner_product
    new_title = ppi[:title_ru].reverse

    assert_difference('(ppi.reload.title_ru.hash == new_title.hash) ? 1 : 0') do
      post :update, partner_product_id: pp, id: ppi, partner_product_item: {title_ru: new_title}
    end 
    assert_redirected_to admin_partner_product_partner_product_items_path(pp)
    assert_response :found
     
  end

  # Archive and restore items
    # ARCHIVE
    test "should archives item" do
      ppi = create :partner_product_item
      assert_equal 'active', ppi.state
      put :destroy, id: ppi
      assert_equal 'deleted', ppi.reload.state
      assert_redirected_to admin_partner_product_partner_product_items_path(ppi.partner_product)
    end

    # DELETED
    # list deleted items
    test "should list of deleted items" do
      create_list :partner_product_item, 2
      
      pp = create :partner_product
      ppis_deleted = create_list :partner_product_item, 2, partner_product: pp
      ppis_deleted.each { |i| i.mark_as_deleted! }

      get :deleted, partner_product_id: pp
      assert_template :deleted
      assert_equal ppis_deleted.map(&:id).sort, assigns(:ppis).map(&:id).sort
    end

    # RESTORE
    test "should restore the items" do
      ppi = create :partner_product_item
      ppi.mark_as_deleted!
      pp = ppi.partner_product

      assert ppi.reload.state == 'deleted'

      put :restore, partner_product_id: pp, id: ppi 
      assert_equal 'active', ppi.reload.state
      assert_redirected_to admin_partner_product_partner_product_items_path(pp)
    end
end

