require_all "features/pages/widgets/"

class Page
  include PageObject
  include DataMagic

  page_url "<%=params[:url]%>"

end
