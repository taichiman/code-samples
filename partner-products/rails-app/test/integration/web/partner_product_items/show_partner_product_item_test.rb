#encoding: utf-8
require 'test_helper'
require 'test_helpers/test_helpers'

class Web::ShowPartnerProductItemTest < ActionDispatch::IntegrationTest
  include TestHelpers

  setup do
    DatabaseCleaner.strategy = :truncation
    Capybara.current_driver = Capybara.javascript_driver
  end

  teardown do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end

  test 'pp item show' do
    create_item

    visit partner_product_path(@pp)

    temp=Capybara.match
    Capybara.match = :first
    click_link 'Подробное описание', href: "/partner-product/catalog/#{@ppi.id}"
    Capybara.match = temp

    within('body') do
      assert assert_text(@ppi.title_ru.upcase) #because in style written 'css text-transform: uppercase'
      assert assert_text(@ppi.description_ru)
    end
  end

  private
  def create_item
    @ppt = create :partner_product_type
    @pp  = create :partner_product, partner_product_type: @ppt
    @ppi = create :partner_product_item, partner_product: @pp
  end
end

