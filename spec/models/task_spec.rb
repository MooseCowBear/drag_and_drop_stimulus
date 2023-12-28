require 'rails_helper'
require 'concerns/draggable_spec'

RSpec.describe Task, type: :model do
  it_behaves_like 'draggable'

  it "is valid when it has a title" do
    task = create(:task)
    expect(task).to be_valid
  end

  it "is not valid when title is missing" do
    task = build(:task, title: "")
    expect(task).not_to be_valid
  end

  describe ".complete" do
    it "returns completed tasks only" do
      completed_task = create(:task, :completed)
      incompleted_task = create(:task, position: 1)
      res = Task.complete
      expect(res.length).to eq(1)
      expect(res.first).to eq(completed_task)
    end
  end

  describe ".incomplete" do
    it "returns incomplete tasks only" do
      completed_task = create(:task, :completed)
      incompleted_task = create(:task, position: 1)
      res = Task.incomplete
      expect(res.length).to eq(1)
      expect(res.first).to eq(incompleted_task)
    end
  end 
end
