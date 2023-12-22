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

  describe ".new_with_postion" do
    it "assigns a new task's position to be one more than the existing max position when existing postion" do
      task = create(:task)
      new_task = Task.new_with_position({ title: "new task" })
      new_task.save
      expect(Task.maximum(:position)).to eq(1)
    end

    it "assigns a new task's position to 0 when there are no tasks yet" do
      new_task = Task.new_with_position({ title: "new task" })
      new_task.save
      expect(Task.maximum(:position)).to eq(0)
    end
  end

  describe ".order_by_position" do
    it "returns tasks in ascending order of position" do
      task = create(:task)
      task1 = create(:task, position: 1)
      task2 = create(:task, position: 2)
      res = Task.order_by_position
      expect(res.first.position).to be <= res.second.position
      expect(res.second.position).to be <= res.last.position
    end
  end
end
