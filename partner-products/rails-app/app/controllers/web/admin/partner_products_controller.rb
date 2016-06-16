#encoding: utf-8
class Web::Admin::PartnerProductsController < Web::Admin::ApplicationController

  def index
    @partner_product_types = prepare_data_for_selects(:partner_product_types)
    @pp_type = get_pp_type_for_the_page(@partner_product_types)

    @partner_products = PartnerProduct.where(partner_product_type_id: @pp_type).active.
      includes(:partner).asc_by_order_at

    session[:last_page_partner_product_type_id] = nil
    disable_caching
  end

  def new
    @partners, @partner_product_types = prepare_data_for_selects(:partners, :partner_product_types)
    @partner_product = PartnerProduct.new
    
    # return to first partner product type, because I don't pass the previous type that selected on pp list
    # by user. My be it is wrong idea. But GSUs
    session[:last_page_partner_product_type_id] = nil
  end

  def edit
    @partners, @partner_product_types = prepare_data_for_selects(:partners, :partner_product_types)
    @partner_product = PartnerProduct.find(params[:id])
    set_pp_type_in_session_for_back_in_browser(@partner_product.partner_product_type)
  end

  def create
    p_id = params[:partner_product][:partner_id]
    @partner = p_id.blank? ? Partner.new : Partner.find(p_id)

    @partner_product = @partner.partner_products.build(params[:partner_product]) 
    
    if @partner_product.save
      set_pp_type_in_session_for_back_in_browser(@partner_product.partner_product_type)
      redirect_to admin_partner_products_path, notice: 'Продукт партнера успешно создан'
    else
      @partners, @partner_product_types = prepare_data_for_selects(:partners, :partner_product_types)
      render :new
    end

  end

  def update
    @partner_product = PartnerProduct.find(params[:id])

    if @partner_product.update_attributes(params[:partner_product])
      redirect_to admin_partner_products_path, notice: 'Продукт партнера обновлен'
    else
      @partners, @partner_product_types = prepare_data_for_selects(:partners, :partner_product_types)
      render 'edit'
    end
    set_pp_type_in_session_for_back_in_browser(@partner_product.partner_product_type)
  end

  def destroy
    partner_product = PartnerProduct.find(params[:id])
    partner_product.mark_as_deleted!
    set_pp_type_in_session_for_back_in_browser(partner_product.partner_product_type)
    redirect_to admin_partner_products_path, notice: 'Продукт партнера отправлен в архив'
  end

  def restore
    partner_product = PartnerProduct.find(params[:id])
    partner_product.restore!
    redirect_to admin_partner_products_path
  end

  def deleted
    @deleted_partner_products = PartnerProduct.includes(:partner).deleted
    ppt = PartnerProductType.find(params[:partner_product_type_id])
    set_pp_type_in_session_for_back_in_browser(ppt)
  end

  def update_index
    @pp_type = PartnerProductType.find(params[:product_type_id])
    @partner_products = PartnerProduct.where(partner_product_type_id:@pp_type.id ).active.includes(:partner)
    
    render layout: false
  end

  private

  def prepare_data_for_selects *keys
    out = []
    keys.each do |k|
      if k == :partners
        out << Partner.active.asc_by_order_at
      end
      if k == :partner_product_types
        out << PartnerProductType.active.asc_by_order_at
      end
    end
    return out.size == 1 ? out.first : out
  end

  def get_pp_type_for_the_page(all_pp_types)
    get_pp_type(all_pp_types)
  end

  def get_pp_type(pp_types)
    if pp_types.blank? # when table pp_types is empty
      pp_type = PartnerProductType.new
    else
      if session[:last_page_partner_product_type_id].blank? # try search a first pp_type with active products
        i = pp_types.index do |t| 
          PartnerProduct.exists?(partner_product_type_id: t.id, state: :active)
        end
        i = 0 if i.nil? #if no active products, then should be first pp_type selected
        pp_type = pp_types[i]
      else
        pp_type = PartnerProductType.find(session[:last_page_partner_product_type_id]) # try return to prev pp_type page
      end
    end

    return pp_type
  end

  def disable_caching
    response.headers["Cache-Control"] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers["Pragma"] = 'no-cache'
    response.headers["Expires"] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

end

