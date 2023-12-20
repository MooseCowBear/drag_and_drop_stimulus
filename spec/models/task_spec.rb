require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid when it has a title" do
    task = create(:task)
    expect(task).to be_valid
  end

  it "is not valid when title is missing" do
    task = build(:task, title: "")
    expect(task).not_to be_valid
  end
end
