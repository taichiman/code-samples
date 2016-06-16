#encoding: utf-8
require 'test_helper'
require 'test_helpers/test_helpers'

class Web::Admin::ChangeSelectOnPartnerProductList < ActionDispatch::IntegrationTest
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

  test 'open partners products page and change pp types select' do
    ppts = create_pp_list
    opt = {selector: 'Тип продукции'}

    visit '/admin/p-products'

    assert_equal '/admin/p-products', current_path
    within('h1') do
      assert page.has_content?('Продукция партнеров'), 'has not the title "Продукция партнеров" on page'
    end

    assert has_select?(opt['selector'], selected: ppts[0].title_ru),
      "no a select with #{ppts[0].title_ru} option selected"

    within('div#partner_products_list table') do
      assert assert_text(ppts[0].partner_products.first.title_ru)
      assert assert_text(ppts[0].partner_products.last.title_ru)
    end


    ###
    # change a partner product type in select

    select ppts[1].title_ru, from: opt['selector']

    within('div#partner_products_list table') do
      assert assert_text(ppts[1].partner_products.first.title_ru)
      assert assert_text(ppts[1].partner_products.last.title_ru)
    end
  end

end

