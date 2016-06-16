class Web::PartnerProductItemsController < Web::ApplicationController

  def show
    @item = PartnerProductItem.find(params[:id])
    @partner_product = @item.partner_product
    @partner = @partner_product.partner


    add_breadcrumb :partner_product, partner_product_path(@item.partner_product_id)
    add_breadcrumb :show

    render 'show'
  end
end

