module PageNameHelpers

  # Revert page name string into page class name
  # @param [String] page name
  # @return[String] Return page class name
  def generate_page_class_name(page_name)
    "#{page_name.split.map(&:capitalize).join('')}Page"
  end
  
  def generate_page_name_key(page_name)
    "#{page_name.split.map(&:downcase).join('_')}_page"
  end

end

World PageNameHelpers
