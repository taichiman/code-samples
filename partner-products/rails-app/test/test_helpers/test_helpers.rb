module TestHelpers
  def sign_in user
    visit '/users/sign_in'
    fill_in 'Email', with: 'admin@sample.com'
    fill_in 'Password', with: '123123123'
    click_on 'Sign in'
  end

  private

  # create partner product items
  # only for 2 pp type and 2 products
  def create_pp_list
    a = []
    2.times { a << create_pp_with_one_ppt }
    a
  end

  def create_pp_with_one_ppt
    ppt = create :partner_product_type
    create_list :partner_product, 2, partner_product_type: ppt
    ppt
  end
  #---

  class ActionDispatch::IntegrationTest
    self.use_transactional_fixtures = false
  end

end

