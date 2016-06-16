#encoding: utf-8
require 'test_helper'
#TODO ref test

class Web::Admin::PartnersControllerTest < ActionController::TestCase
  setup do
    user = create :user
    sign_in user

    @partner_attrs = attributes_for :partner
  end

  #NEW
  def test_new
    get :new
    assert_response :success
    assert_template :new
  end

  def test_new_when_not_logged
    sign_out :user
    get :new
    assert_response :found
  end

  #CREATE
  def test_create_with_valid_params
    assert_difference('Partner.count', 1, 'add one record') {
      post :create, partner: @partner_attrs
    }
    assert_redirected_to admin_partners_path
    assert_equal "Партнер добавлен", flash[:notice]
  end

  def test_create_with_invalid_params
    invalid_attrs = @partner_attrs.merge(name_ru: '')
    assert_no_difference('Partner.count', 'should\'t add one record') { 
      post :create, partner: invalid_attrs
    }
    assert_template :new
  end

  #INDEX
  def test_get_index
    @active_partners = []
    create :partner, state: :deleted
    2.times  { @active_partners << create(:partner) } 
    @active_partners = Partner.where(state: :active)

    get :index
    assert @active_partners.to_ary == assigns[:partners].to_ary, 
           'should by only active partner records assigns'
    assert_template :index
    assert_response :success
    
  end


  #DELETE
  #archive the partner
  def test_should_archive_partner
    partner = create :partner

    assert_difference('Partner.count',0,'archive one partner') {
      delete :destroy, id: partner
    }

    active = Partner.active.find_by_id(partner.id)
    deleted = Partner.deleted.find_by_id(partner.id)
    assert_nil active
    assert_not_nil deleted
    
    assert_response :found
    assert_redirected_to admin_partners_path
    assert_equal 'Партнер отправлен в архив', flash[:notice]

  end

  def test_should_not_destroy_partner_when_not_logged
    sign_out :user
    partner = create :partner
    assert_no_difference('Partner.find(partner.id).state.hash','partner not archived') do
      delete :destroy, id: partner
    end

  end


  #DELETED
  #list of archived partners

  def test_show_list_archived_partners
    get :deleted

    assert_response :success
    assert_template :deleted
  end
  
  #RESTORE
  #restore the archived partner

  def test_restore_of_archived_partner
    archived = create :partner, deleted_at: Time.current, state: :deleted

    post :restore, id: archived
    assert_equal 'active', archived.reload.state, 'should set active to partner'
    assert_nil archived.reload.deleted_at, 'should delete deleted_at time'

    assert_response :found
    assert_redirected_to admin_partners_path

  end

  #EDIT
  #edit a partner
  def test_edit
    @partner = create :partner
    get :edit, id: @partner

    assert_response :success
    assert_template :edit

  end

  #UPDATE
  test 'should put update partner' do
    @partner = create :partner

    put :update, id: @partner
    assert_redirected_to admin_partners_url, 'not redirect on partners list'

  end

end

