#encoding: utf-8
require 'test_helper'
require 'test_helpers/test_helpers'

class Web::ShowPartnerProductWithCatalogItemsTest < ActionDispatch::IntegrationTest
  include TestHelpers

  setup do
    DatabaseCleaner.strategy = :truncation
    Capybara.current_driver = Capybara.javascript_driver
  end

  teardown do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end

  test 'whole pp index page' do
    create_pp_with_items

    visit partner_product_path(@pp)

    within('.partnerProductView-header') do
      assert assert_text(@ppt.title_ru.upcase) #because in style written 'css text-transform: uppercase'
      assert assert_text(@pp.partner.name_ru)
      assert assert_text(@pp.description_ru)
    end

    within('.partnerProductView-catalog') do
      assert assert_text(@ppis[0].title_ru)
      assert assert_text(@ppis[1].title_ru)
      assert assert_no_text(@deleted_item.title_ru)
    end

  end

  private
  def create_pp_with_items
    @ppt = create :partner_product_type
    @pp = create :partner_product, partner_product_type: @ppt
    @ppis = []
    2.times { @ppis << create(:partner_product_item, partner_product: @pp) }

    @deleted_item = create(:partner_product_item, partner_product: @pp)
    @deleted_item.mark_as_deleted!
  end
end

