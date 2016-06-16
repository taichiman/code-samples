#encoding: utf-8
require 'test_helper'
Rails.logger = Logger.new(STDOUT)

class Web::Admin::PartnerProductsControllerTest < ActionController::TestCase
  setup do
    user = create :user
    sign_in user
    @partner = create :partner
    @partner_product_type = create :partner_product_type
    @partner_product = create :partner_product
  end

  #INDEX
  test "should return index of active partner's products" do
    Partner.delete_all
    PartnerProduct.delete_all
    PartnerProductType.delete_all

    create_list :partner_product, 2, partner_product_type: (create :partner_product_type)
    pp_list = create_list :partner_product, 2, partner_product_type: (create :partner_product_type)
    pp_type = pp_list.sample.partner_product_type
    create :partner_product, state: :deleted
    
    session[:last_page_partner_product_type_id] = pp_type.id

    get :index, {} 
    assert_template :index
    assert_response :success

    assert_equal ['active'], assigns(:partner_products).map(&:state).uniq

    pp_assigned = assigns(:partner_products).map(&:partner_product_type).map(&:id).uniq
    assert_equal 1, pp_assigned.size, 'products with only one type should be listed'
    assert_equal pp_type.id, pp_assigned.sample, 'should be only common pp_type for group of pp'

  end

  test "should test edge cases for select" do
    Partner.delete_all
    PartnerProduct.delete_all
    PartnerProductType.delete_all

    get :index
    assert_response :success
    assert_template :index
  end

  # when first time enter to partner products list, pp_type in route wil set in ''
  # defaults: { partner_product_type_id: '' }
  test 'should show index, when pp_type = nil' do
    Partner.delete_all
    PartnerProduct.delete_all
    PartnerProductType.delete_all

    @partner = create_list :partner, 2
    @partner_product_type = create_list :partner_product_type, 2

    #assert_nothing_raised 'should\'nt trow exception Type error. no implicit conversion from nil to integer' do
      get :index, {partner_product_type_id: ''}
    #end
    
    assert_response :success
  end
  
  #NEW
  test "should return form for new partner product" do
    ppt_archived = create :partner_product_type
    ppt_archived.mark_as_deleted!
    p_archived = create :partner
    p_archived.mark_as_deleted!

    get :new
    assert_equal assigns(:partner_product_types).map(&:id).sort, PartnerProductType.active.map(&:id).sort
    assert_equal assigns(:partners).map(&:id).sort, Partner.active.map(&:id).sort
    assert_response :success
    assert_template :new
  end

  #CREATE
  test "should create valid product" do
    assert_equal 0, @partner.reload.partner_products.count
    assert_equal 0, @partner_product_type.reload.partner_products.count

    post :create, partner_product: {partner_id: @partner, 
                                    partner_product_type_id: @partner_product_type, 
                                    title_ru: generate(:string),
                                    description_ru: generate(:text)}

    assert_equal 1, @partner.reload.partner_products.count
    assert_equal 1, @partner_product_type.reload.partner_products.count

    assert_redirected_to admin_partner_products_path
    assert_equal 'Продукт партнера успешно создан', flash[:notice]
    assert_equal session[:last_page_partner_product_type_id], @partner_product_type.id, 'should set last pp_type page in session'

  end

  test "should\'t create invalid product" do
    assert_difference('@partner.reload.partner_products.size', 0) do
      post :create, partner_product: {partner_id: @partner, title_ru: ''}
    end
    assert_template :new

  end

  test "should\'t create invalid product without partner" do
    assert_nothing_raised ActiveRecord::RecordNotFound do
      post :create, 
        partner_product: {
          "partner_product_type_id"=>"",
          "partner_id"=>"",
          "title_ru"=>"",
          "description_ru"=>""
        }
    end
    assert_template :new
  end

  # EDIT
  test "should edit a partner\'s product" do
    get :edit, id: @partner_product
    assert_response :success
    assert_template :edit
  end

  #UPDATE
  test "should update partner's product with valid data, wheh title changed" do
    new_title = 'new title - foo bar baz'

    assert_difference "PartnerProduct.where(title_ru: new_title).count", 1 do
      put :update, id: @partner_product, 
                   partner_product: {title_ru: new_title}
    end

    assert_redirected_to admin_partner_products_path

    assert_equal @partner_product.partner_product_type.id, session[:last_page_partner_product_type_id], 'set pp_type last page in session'
    assert_equal'Продукт партнера обновлен', flash[:notice], 'flash notice'

  end

  test "should update partner's product with valid data, when partner changed" do
    assert_difference "PartnerProduct.where(partner_id: @partner).count", 1 do
      put :update, id: @partner_product, partner_product: {partner_id: @partner}
    end
    assert_redirected_to admin_partner_products_path
  end

  test "shouldn\'t update partner\'s product with invalid data" do
    assert_difference "@partner_product.reload.title_ru.size", 0 do
      put :update, id: @partner_product, partner_product: {title_ru: ''}
    end
    assert_template :edit
    
  end

  # DELETE
  # send to archive
  test 'should archive partner product' do
    2.times { create :partner_product }
    partner_product = PartnerProduct.first

    assert_difference('PartnerProduct.active.size', -1, 'should set state in deleted') {
      delete :destroy, id: partner_product
    }

    assert_redirected_to admin_partner_products_path
    assert_equal flash[:notice], 'Продукт партнера отправлен в архив'
  end

  # RESTORE
  # restore from archive
  test "should restore form archive" do
    2.times { create :partner_product }
    partner_product = PartnerProduct.first
    partner_product.mark_as_deleted!

    assert_difference('PartnerProduct.active.size', 1, 'should set state to active') {
      put :restore, id: partner_product
    }

    assert_nil partner_product.reload.deleted_at, 'should delete deleted_at time'
    assert_redirected_to admin_partner_products_path
  end

  # DELETED
  # list deleted partner products
  test 'should list deleted products' do
    ppt = create :partner_product_type
    2.times { create :partner_product, partner_product_type: ppt }
    partner_product = PartnerProduct.first
    partner_product.mark_as_deleted!
    
    get :deleted, partner_product_type_id: ppt

    assert_template 'deleted'
    assert_equal 1, assigns(:deleted_partner_products).size
   
  end

  # UPDATE_INDEX
  # update index when user select a new product_type in select combo
  test 'should return index, filtered by product_type' do
    %w(PartnerProduct PartnerProductType).each { |m| m.constantize.delete_all  }
    partner_product = {}
    2.times do |i|
      t = create :partner_product_type
      products = create_list :partner_product, 3, partner_product_type: t
      products.last.mark_as_deleted!
      partner_product["type_#{i}".to_sym] = products
    end

    assert_recognizes({controller: 'web/admin/partner_products', action: 'update_index', product_type_id: '1'},
      '/admin/partner_products/update_index/1')

    get :update_index, product_type_id: partner_product[:type_1].first.partner_product_type_id

    assert_equal(
      partner_product[:type_1].select { |p| p.active? }.map(&:id).sort,
      assigns(:partner_products).map(&:id).sort
    )

    assert_template :update_index

  end
end

