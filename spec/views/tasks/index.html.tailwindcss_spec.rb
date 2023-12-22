require 'rails_helper'

RSpec.describe "tasks/index.html.erb", type: :view do
  it "renders each task" do
    task1 = create(:task, title: "task 1")
    task2 = create(:task, title: "task 2", position: 1)
    assign(:tasks, [task1, task2])
    render
    expect(rendered).to have_content(/task 1/i)
    expect(rendered).to have_content(/task 2/i)
  end

  it "renders a link to new task" do
    assign(:tasks, [])
    render
    expect(rendered).to have_link "new task", href: new_task_path
  end
end
