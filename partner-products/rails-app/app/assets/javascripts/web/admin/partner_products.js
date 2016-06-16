function update_partner_products_list_div(partner_type_id) {
  jQuery.ajax({
    url: '/admin/partner_products/update_index/' + partner_type_id,
    type: 'GET',
    dataType: "html",
    success: function(data) {
      jQuery('#partner_products_list').html(data);
      init_sortable();
    }
  });
}
