require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  it "can create a new task" do
    visit tasks_path
    have_selector "h1", "Tasks"

    # click_on "new task"
    # fill_in "title", with: "task test"
    # click_on "Create Task"

    # assert_selector "h2", "task test"
  end
end