#encoding: utf-8

class PartnerProductsHelperTest < ActionView::TestCase
  include Web::Admin::PartnerProductsHelper

  class CatalogItemBadgeTest < PartnerProductsHelperTest
    test 'when pp items absent' do
      pp = create :partner_product 

      assert_equal 'foo', catalog_items_count(pp, 'foo')
    end

    test 'when pp items present' do
      pp = create :partner_product 
      times = rand(1..5)
      ppi = times.times { create :partner_product_item, partner_product: pp }

      assert_equal "bar (#{times})", catalog_items_count(pp, 'bar')
    end
  end

end

