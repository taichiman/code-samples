#encoding: utf-8

class Web::Admin::PartnerProductItemsController < Web::Admin::ApplicationController
  before_filter :set_partner_product, except: [:edit, :destroy]

  def new
    @ppi = @pp.partner_product_items.build
  end

  def create
    @ppi = @pp.partner_product_items.build(params[:partner_product_item])
    if @ppi.save
      redirect_to admin_partner_product_partner_product_items_path, notice: 'Товар партнера успешно создан'
    else
      render 'new'
    end
  end

  def index
    @ppis = @pp.partner_product_items.active.asc_by_order_at
    set_pp_type_in_session_for_back_in_browser(@pp.partner_product_type)
  end

  def edit
    @ppi = PartnerProductItem.find(params[:id])
    @pp = @ppi.partner_product
  end

  def update
    @ppi = @pp.partner_product_items.find(params[:id])
    if @ppi.update_attributes(params[:partner_product_item])
      redirect_to admin_partner_product_partner_product_items_path(@pp.id)
    else
      render 'edit'
    end
  end

  def destroy
    ppi = PartnerProductItem.find(params[:id])
    ppi.mark_as_deleted!
    redirect_to admin_partner_product_partner_product_items_path(ppi.partner_product_id), 
      notice: 'Товар отправлен в архив.'
  end

  def deleted
    @ppis = @pp.partner_product_items.deleted.by_deleted_at
    set_pp_type_in_session_for_back_in_browser(@pp.partner_product_type)

  end

  def restore
    ppi = @pp.partner_product_items.find(params[:id])
    ppi.restore!
    redirect_to admin_partner_product_partner_product_items_path(@pp), 
      notice: 'Товар восстановлен из архива'
  end

  private
  def set_partner_product
    @pp = PartnerProduct.find(params[:partner_product_id])
  end

end

