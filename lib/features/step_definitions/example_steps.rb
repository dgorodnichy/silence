Then(/^I see social panel$/) do
  p @current_page.social_panel_element #.example_action
  expect(@current_page.social_panel_element.exists?).to be true
end

Then /^I fill registration form$/ do
 filled_data = @current_page.fill_registration_form
 @current_page.submit_form
end

Then /^I wait wrong element$/ do
  @browser.wait_until(1, "Error") do
    @browser.div(:id => 'asd').exists?
  end
end

Then /^I open broken page$/ do
  @browser.goto("http://eurail.ecodev.d7.acquia.adyax.com/")
end
