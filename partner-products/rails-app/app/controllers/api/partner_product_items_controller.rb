class Api::PartnerProductItemsController < Api::ApplicationController
  def mass_update_order_at
    ids = params[:ids]
    ids.each_with_index do |ppi_id, place| 
      PartnerProductItem.find(ppi_id).
              update_column(:order_at, place)
    end

    head :ok

  end

end

