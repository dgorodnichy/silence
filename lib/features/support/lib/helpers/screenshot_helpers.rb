module Screenshot
  def embed_screenshot(filename)
    @browser.screenshot.save filename
    embed filename, 'image/png'
  end
end

World Screenshot

