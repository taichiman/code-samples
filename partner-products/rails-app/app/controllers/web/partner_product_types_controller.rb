class Web::PartnerProductTypesController < Web::ApplicationController
  add_breadcrumb :index, :partner_product_types_path 

  def index
    @partner_product_types = PartnerProductType.active.asc_by_order_at
  end

  def show
    add_breadcrumb :show

    @pp_type = PartnerProductType.find(params[:id])
    @partner_products = PartnerProduct.where(partner_product_type_id: @pp_type).active.asc_by_order_at

  end
end

