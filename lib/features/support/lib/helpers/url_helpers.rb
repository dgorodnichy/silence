module UrlHelpers
  
  # Return all defined project urls 
  # @return[Hash] project urls
  def project_urls
    DataMagic.load('urls.yml')[ENV["ENVIRONMENT"]]
  end

end

World UrlHelpers
