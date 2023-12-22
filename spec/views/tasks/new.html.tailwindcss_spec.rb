require 'rails_helper'

RSpec.describe "tasks/new.html.erb", type: :view do
  it "renders a form" do
    assign(:task, Task.new)
    render
    expect(rendered).to have_content("New Task")
    expect(rendered).to have_selector("form")
  end
end
