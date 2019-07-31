require 'rails_helper'

RSpec.describe 'User Profile Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @address = @user.addresses.create(streetname: "123 market", city: "Denver", state: "CO", zip: 80132)
      @address2 = @user.addresses.create(nickname: "work", streetname: "123 main", city: "Springfield", state: "IL", zip: 12345)
      # @order_1 = @user.orders.create!(address_id: @address.id)
      @order_2 = @user.orders.create!(status: "shipped", address_id: @address2.id)
      # @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @hippo.price, quantity: 2)
    end

    it "user can delete an address" do
      visit "/login"

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      visit profile_path

      within "#address-#{@address.id}" do
        expect(page).to have_content("Edit Address")
        click_on "Delete Address"
      end

      expect(current_path).to eq(profile_path)

      expect(page).to_not have_content(@address.id)

    end

    it "user cannot" do
      visit "/login"

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      visit profile_path
       # save_and_open_page

      within "#address-#{@address2.id}" do
        expect(page).to_not have_content("Delete Address")
        expect(page).to_not have_content("Edit Address")
        end

    end

  end
end
