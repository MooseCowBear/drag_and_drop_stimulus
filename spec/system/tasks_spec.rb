require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  it "can create a new task when input is valid" do
    visit tasks_path

    click_on "new task"
    fill_in "title", with: "task test"
    click_on "Create Task"

    expect(page).to have_selector("h2", text: "task test")
  end

  it "displays error message if title is missing" do
    visit tasks_path

    click_on "new task"
    fill_in "title", with: ""
    click_on "Create Task"

    expect(page).to have_selector("span", text: /title can't be blank/i)
  end

  it "displays tasks in order of position" do
    create_list(:task_list, 3)

    visit tasks_path
    expect(page).to have_content /Task1.*Task2.*Task3/m
  end

  it "opens edit form when edit button is pressed" do
    create(:task, title: "test task")

    Capybara.enable_aria_label = true
    visit tasks_path

    find_link('edit task', match: :first).click

    expect(page).to have_selector("form")
  end

  it "updates task when input is valid" do
    create(:task, title: "test task")

    Capybara.enable_aria_label = true
    visit tasks_path

    find_link('edit task', match: :first).click

    fill_in"title", with: "Updated Title"
    click_on "Update Task"

    expect(page).to have_selector("h2", text: "Updated Title")
  end

  it "removes task from tasks display if deleted" do
    create(:task)

    visit tasks_path 

    accept_confirm do
      find_button('delete', match: :first).click
    end

    expect(page).to have_none_of_selectors("h2", text: "task")
  end
end