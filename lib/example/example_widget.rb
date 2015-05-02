class ExampleWidget < PageObject::Elements::Div

  def example_action
    hello
  end

  protected

  def hello
    "Hello, I am the widget"
  end

  PageObject.register_widget :example_widget, ExampleWidget, :div
end
