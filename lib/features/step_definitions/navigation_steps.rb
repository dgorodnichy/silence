Given /^I go to the "(.*)" page$/ do |page_name|
  raise "Subdomain is not defined." if @subdomain.nil?
  steps %{ Given I go to the "#{page_name}" page on "#{@subdomain}" subdomain }
end

Given /^I go to the "(.*)" page on "(.*)" subdomain$/ do |page_name, subdomain|
  @subdomain = subdomain
  page_name_class = generate_page_class_name(page_name)
  page_name_key = generate_page_name_key page_name
  visit_page page_name_class, :using_params =>{:url => project_urls[subdomain][page_name_key]} do |page|
    puts "I am on #{page.current_url}" 
  end
end
    
Given /^I set "(.*)" subdomain$/ do |subdomain|
  puts "I am on #{subdomain} subdomain"
  @subdomain = subdomain
end
