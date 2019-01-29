require 'rails_helper'
# MOD
feature 'Admin tests' do
  background do
    @admin = create(:administrator)
    @user  = create(:user, username: 'Jose Luis Balbin')
    @test = create(:test)
    login_as(@admin.user)
    visit admin_tests_path
  end

  scenario 'Index' do
    expect(page).to have_content @test.name
    expect(page).to have_content @test.email
    expect(page).not_to have_content @user.name
  end

  scenario 'Create Test', :js do
    fill_in 'name_or_email', with: @user.email
    click_button 'Search'

    expect(page).to have_content @user.name
    click_link 'Add'
    within("#tests") do
      expect(page).to have_content @user.name
    end
  end

  scenario 'Delete Test' do
    click_link 'Delete'

    within("#tests") do
      expect(page).not_to have_content @test.name
    end
  end

  context 'Search' do

    background do
      user  = create(:user, username: 'Elizabeth Bathory', email: 'elizabeth@bathory.com')
      user2 = create(:user, username: 'Ada Lovelace', email: 'ada@lovelace.com')
      @test1 = create(:test, user: user)
      @test2 = create(:test, user: user2)
      visit admin_tests_path
    end

    scenario 'returns no results if search term is empty' do
      expect(page).to have_content(@test1.name)
      expect(page).to have_content(@test2.name)

      fill_in 'name_or_email', with: ' '
      click_button 'Search'

      expect(page).to have_content('Tests: User search')
      expect(page).to have_content('No results found')
      expect(page).not_to have_content(@test1.name)
      expect(page).not_to have_content(@test2.name)
    end

    scenario 'search by name' do
      expect(page).to have_content(@test1.name)
      expect(page).to have_content(@test2.name)

      fill_in 'name_or_email', with: 'Eliz'
      click_button 'Search'

      expect(page).to have_content('Tests: User search')
      expect(page).to have_content(@test1.name)
      expect(page).not_to have_content(@test2.name)
    end

    scenario 'search by email' do
      expect(page).to have_content(@test1.email)
      expect(page).to have_content(@test2.email)

      fill_in 'name_or_email', with: @test2.email
      click_button 'Search'

      expect(page).to have_content('tests: User search')
      expect(page).to have_content(@test2.email)
      expect(page).not_to have_content(@test1.email)
    end
  end

end
# END OF MOD