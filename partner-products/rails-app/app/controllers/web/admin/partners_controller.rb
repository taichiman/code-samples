#encoding: utf-8
 
#TODO: привести style к виду anothers controllers
#TODO: после добавления новго parnter, its sort are brocken

class Web::Admin::PartnersController < Web::Admin::ApplicationController
  def index
    @partners = Partner.active.asc_by_order_at
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(params[:partner])
    if @partner.save
      redirect_to admin_partners_path, notice: 'Партнер добавлен'
    else
      render action: 'new'
    end
  end

  def edit
    @partner = Partner.find(params[:id])
    render :edit

  end

  def update
    @partner = Partner.find(params[:id])

    if @partner.update_attributes(params[:partner])
      redirect_to admin_partners_url
    else
      render :edit
    end

  end

  def destroy
    partner = Partner.find(params[:id])
    partner.mark_as_deleted!
    redirect_to admin_partners_path, notice: 'Партнер отправлен в архив'

    #TODO deleted at location
  end

  def deleted
    @partners = Partner.deleted.by_deleted_at
  end

  def restore
    partner = Partner.find(params[:id])
    partner.restore!
    redirect_to admin_partners_path
  end
end

