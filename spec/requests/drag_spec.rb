require 'rails_helper'

RSpec.describe "Drags", type: :request do
  describe "POST /drag" do
    before(:each) do
      @task0 = create(:task)
      @task1 = create(:task, position: 1)
      @task2 = create(:task, position: 2)
    end

    it "updates the positions of tasks whose ids are included in params" do
      post drag_url, params: {drag: { category: "tasks", ids: [@task0.id, @task1.id], positions: [1, 0] } }
      @task0.reload
      @task1.reload
      expect(@task0.position).to eq(1)
      expect(@task1.position).to eq(0)
    end

    it "does not update tasks whose ids are not included in params" do
      post drag_url, params: {drag: { category: "tasks", ids: [@task0.id, @task1.id], positions: [1, 0] } }
      @task2.reload
      expect(@task2.position).to eq(2)
    end
  end
end
