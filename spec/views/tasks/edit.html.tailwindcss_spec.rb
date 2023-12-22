require 'rails_helper'

RSpec.describe "tasks/edit.html.erb", type: :view do
  it "renders a form" do
    task = create(:task)
    assign(:task, task)
    render
    expect(rendered).to have_content("Edit Task")
    expect(rendered).to have_selector("form")
    expect(rendered).to have_link "See this task", href: task_path(task)
    expect(rendered).to have_link "Back to tasks", href: tasks_path
  end
end
