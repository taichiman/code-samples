#encoding: utf-8
require 'test_helper'
require 'test_helpers/test_helpers'

class Web::Admin::ChangeArchiveLinkWhenChangePartnerProductTypeInSelectTest < ActionDispatch::IntegrationTest
  include TestHelpers

  setup do
    DatabaseCleaner.strategy = :truncation
    Capybara.current_driver = Capybara.javascript_driver
    sign_in create(:admin)
  end

  teardown do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end

  test 'change archive link to right url' do
    ppts = create_pp_list
    first_ppt = ppts[0]
    second_ppt = ppts[1]
    first_pp = first_ppt.partner_products
    second_pp = second_ppt.partner_products
    opt = {selector: 'Тип продукции'}

    visit '/admin/p-products'

    within('div#partner_products_list table') do
      assert assert_text(first_pp.first.title_ru)
      assert assert_text(first_pp.last.title_ru)
    end

    # main test assertion
    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{first_ppt.id}/deleted")

    # select next partner product type in select
    select second_ppt.title_ru, from: opt['selector']

    within('div#partner_products_list table') do
      assert assert_text(second_pp.first.title_ru)
      assert assert_text(second_pp.last.title_ru)
    end

    # main test assertions
    assert has_link?('Архивная продукция партнеров', href: "/admin/p-products/#{second_ppt.id}/deleted")

  end
end

