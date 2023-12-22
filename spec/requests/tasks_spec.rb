require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get tasks_url
      expect(response).to have_http_status(:success)
    end

    it "response body includes incomplete tasks" do
      create(:task, title: "test task")
      get tasks_url
      expect(response.body).to include("test task")
    end
  end

  describe "GET /show" do
    before(:each) do
      @task = create(:task, title: "test task")
    end

    it "returns http success" do
      get task_url(@task)
      expect(response).to have_http_status(:success)
    end

    it "displays task info" do
      get task_url(@task)
      expect(response.body).to include("test task")
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_task_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      task = create(:task)
      get edit_task_url(task)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
    
      it "creates a new task" do
        expect {
          post tasks_url, params: { task: { title: "a task title" } }
        }.to change(Task, :count).by(1)
      end

      it "redirects to root" do
        post tasks_url, params: { task: { title: "a task title" } }
        expect(response).to redirect_to(root_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new task" do
        expect {
          post tasks_url, params: { task: { title: "" } }
        }.not_to change(Task, :count)
      end

      it "responds with unprocessable" do
        post tasks_url, params: { task: { title: "" } }
        expect(response).to be_unprocessable
      end
    end
  end

  describe "POST /update" do
    before(:each) do
      @task = create(:task)
    end

    context "with valid parameters" do
      it "updates the task" do
        patch task_url(@task), params: { task: { title: "new task title" } }
        @task.reload
        expect(@task.title).to eq("new task title")
      end

      it "redirects to task page" do
        patch task_url(@task), params: { task: { title: "new task title" } }
        expect(response).to redirect_to(task_url(@task))
      end
    end

    context "with invalid parameters" do
      it "does not update task" do
        patch task_url(@task), params: { task: { title: "" } }
        @task.reload
        expect(@task.title).to eq("task")
      end

      it "responds with unprocessable entity" do
        patch task_url(@task), params: { task: { title: "" } }
        expect(response).to be_unprocessable
      end
    end
   end

  describe "DELETE /destroy" do
    before(:each) do
      @task = create(:task)
    end
    
    it "deletes the task" do
      expect {
          delete task_url(@task)
        }.to change(Task, :count).by(-1)
    end

    it "redirects to root url" do
      delete task_url(@task)
      expect(response).to redirect_to(root_url)
    end
  end

end
