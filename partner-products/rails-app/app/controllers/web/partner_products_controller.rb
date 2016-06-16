class Web::PartnerProductsController < Web::ApplicationController
  add_breadcrumb :ppt_index, :partner_product_types_path 

  def show
    add_breadcrumb :show

    @partner_product = PartnerProduct.includes(:partner_product_items).find(params[:id])

  end

end

