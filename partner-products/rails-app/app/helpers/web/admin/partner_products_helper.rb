module Web::Admin::PartnerProductsHelper
  def catalog_items_count(pp, title)
    count = pp.partner_product_items.active.count
    if count > 0
      "#{title} (#{count})"
    else
      title
    end
  end
end

