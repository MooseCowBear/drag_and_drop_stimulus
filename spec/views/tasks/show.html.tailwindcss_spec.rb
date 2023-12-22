require 'rails_helper'

RSpec.describe "tasks/show.html.erb", type: :view do
  it "renders task information" do
    task = create(:task, title: "test task", description: "this is what the task involves")
    assign(:task, task)
    render
    expect(rendered).to have_content(/test task/i)
    expect(rendered).to have_content(/this is what the task involves/i)
    expect(rendered).to have_selector("form") # how check for action?
    expect(rendered).to have_link nil, href: edit_task_path(task)
  end
end
