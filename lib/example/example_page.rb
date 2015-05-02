class ExamplePage < Page

  text_field :email, :id => 'mail'
  checkbox :show_password, :id => 'showPassword'
  text_field :password, :id => 'visible-password'
  select_list :know_about_us, :name => 'informationSource'
  text_field :first_last_name, :name => 'fio'
  text_field :telephone, :name => 'phone'
  select_list :language, :name => 'language'
  select_list :purpose_of_registration, :name => 'registrationPurpose'
  checkbox :accept, :id => 'agreement'

  def fill_registration_form
    DataMagic.load 'user_registration_dataset.yml'
    populate_page_with data_for :registration_form
  end

end

