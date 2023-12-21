class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    # TODO: if update new form to be in turboframe, update this as well

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "Task was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.turbo_stream
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@task)}_form", partial: "form", locals: { task: @task }) }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@task)}_container") }
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :category, :priority)
  end
end
