#encoding: utf-8
# TODO: no name of loaded image in edit action

class Web::Admin::PartnerProductTypesController < Web::Admin::ApplicationController
  def new
    @pp_type = PartnerProductType.new
  end

  def create
    @pp_type = PartnerProductType.new(params[:partner_product_type])
    if @pp_type.save
      redirect_to admin_partner_product_types_path, notice: 'Тип успешно создан'
    else
      render :new
    end
  end

  def index
    @pp_types = PartnerProductType.active.asc_by_order_at
  end

  def edit
    @pp_type = PartnerProductType.find(params[:id])  
  end

  def update
    @pp_type = PartnerProductType.find(params[:id])
    if @pp_type.update_attributes(params[:partner_product_type])
      redirect_to admin_partner_product_types_path, notice: 'Тип обновлен'
    else
      Rails.logger.debug "errors = #{@pp_type.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    @pp_type = PartnerProductType.find(params[:id])
    @pp_type.mark_as_deleted!
    redirect_to admin_partner_product_types_path
  end

  def deleted
    @pp_types = PartnerProductType.deleted.by_deleted_at
  end

  def restore
    @pp_type = PartnerProductType.find(params[:id])
    @pp_type.restore!
    redirect_to admin_partner_product_types_path
  end

end

