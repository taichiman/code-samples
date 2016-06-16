#encoding: utf-8
require 'test_helper'
require 'test_helpers/test_helpers'

class Web::Admin::ShowPartnerProductsListTest < ActionDispatch::IntegrationTest
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

  test 'whole pp index page' do
    create_pp_with_items

    visit '/admin/p-products'

    within('div#partner_products_list table') do
      assert assert_text(@pp.title_ru)
      assert assert_text('Каталог (2)')
    end

  end

  private
  def create_pp_with_items
    @ppt = create :partner_product_type
    @pp = create :partner_product, partner_product_type: @ppt
    @ppis = 2.times { create :partner_product_item, partner_product: @pp }
  end
end

