require 'rspec/expectations'
require 'page-object'
require 'watir-webdriver'
require 'require_all'
require 'headless'

# require all necessary classes
require_all 'features/pages'
require_all 'features/support/lib'

#setup_env_params

if ENV['HEADLESS'] == "true" 
  headless = Headless.new.start
end

if ENV['BROWSER_PATH']
  Selenium::WebDriver::Firefox.path = ENV['BROWSER_PATH']
end

if ENV['BROWSER'] == 'firefox'
  if ENV['PROFILE_NAME']
    browser = Watir::Browser.new :firefox, :profile => ENV['PROFILE']
  elsif ENV['BROWSER_PROFILE_PATH']
    profile_path = "#{Dir.getwd}#{ENV['BROWSER_PROFILE_PATH']}"
    profile = Selenium::WebDriver::Firefox::Profile.new(profile_path)
    browser = Watir::Browser.new :firefox, :profile => profile
  else
    browser = Watir::Browser.new :ff
  end

end

browser.driver.manage.timeouts.implicit_wait=10

# Include framework modules
World PageObject::PageFactory

Before do |scenario|
  @browser = browser
end

After do |scenario|
  screenshot_timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S").gsub(" ", "_")
  embed_screenshot("reports/#{screenshot_timestamp}screenshot.png") if scenario.failed?
end

at_exit do
  browser.close
end
