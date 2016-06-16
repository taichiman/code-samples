#encoding: utf-8
require 'test_helper'
require 'test_helpers/test_helpers'

class Web::Admin::SemanticTransparencyWhenBackToPartnerProductTest < ActionDispatch::IntegrationTest
  include TestHelpers
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.strategy = :truncation
    Capybara.current_driver = Capybara.javascript_driver
    sign_in create(:admin)
  end

  teardown do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end

  test 'press browser back in partner products, after edit' do
    rig_test_data

    visit '/admin/p-products'

    # select next partner product type in select
    select @second_ppt.title_ru, from: @opt['selector']

    click_link 'Править', href: "/admin/p-products/#{@second_pp.first.id}/edit"
    go_back

    # main test assertions
    # we check that there is right partner data
    within('div#partner_products_list table') do
      assert assert_text(@second_pp.first.title_ru)
      assert assert_text(@second_pp.last.title_ru)
    end

    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{@second_ppt.id}/deleted")
  end

  test 'press browser back in partner products after delete' do
    rig_test_data

    visit '/admin/p-products'

    # select next partner product type in select
    select @second_ppt.title_ru, from: @opt['selector']

    accept_alert do
      click_link 'Удалить', href: "/admin/p-products/#{@second_pp.first.id}"
    end

    # main test assertions
    # we check that there is right partner data
    within('div#partner_products_list table') do
      assert assert_text(@second_pp.first.title_ru)
      assert assert_text(@second_pp.last.title_ru)
    end

    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{@second_ppt.id}/deleted")
  end
 
  test 'press back in the partner products list after seeing the catalog' do
    rig_test_data

    visit '/admin/p-products'

    # select next partner product type in select
    select @second_ppt.title_ru, from: @opt['selector']

    click_link 'Каталог', href: "/admin/p-products/#{@second_pp.first.id}/items"
    go_back

    # main test assertions
    # we check that there is right partner data
    within('div#partner_products_list table') do
      assert assert_text(@second_pp.first.title_ru)
      assert assert_text(@second_pp.last.title_ru)
    end

    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{@second_ppt.id}/deleted")
  end

  test 'press back in the partner products list after seeing the archived products' do
    rig_test_data

    visit '/admin/p-products'

    # select next partner product type in select
    select @second_ppt.title_ru, from: @opt['selector']

    click_link 'Архивная продукция партнеров', href: "/admin/p-products/#{@second_ppt.id}/deleted"
    go_back

    # main test assertions
    # we check that there is right partner data
    within('div#partner_products_list table') do
      assert assert_text(@second_pp.first.title_ru)
      assert assert_text(@second_pp.last.title_ru)
    end

    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{@second_ppt.id}/deleted")
  end
 
  test 'press back in the partner products list after adding new product' do
    rig_test_data

    visit '/admin/p-products'

    # select next partner product type in select
    select @second_ppt.title_ru, from: @opt['selector']

    click_link 'Добавить'
    go_back

    # main test assertions
    assert has_select?(@opt['selector'], selected: @first_ppt.title_ru),
      "no a select with #{@first_ppt.title_ru} option selected"

    # we check that there is right partner data
    within('div#partner_products_list table') do
      assert assert_text(@first_pp.first.title_ru)
      assert assert_text(@first_pp.last.title_ru)
    end

    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{@first_ppt.id}/deleted")
  end
 
  private
  def rig_test_data
    @ppts = create_pp_list
    @first_ppt = @ppts[0]
    @second_ppt = @ppts[1]
    @first_pp = @first_ppt.partner_products
    @second_pp = @second_ppt.partner_products
    @opt = {selector: 'Тип продукции'}
  end
end

