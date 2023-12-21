class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :update_status]

  def index
    @tasks = Task.incomplete.order_by_position
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new_with_position(task_params)
    pp @task

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

  def update_status
    @task.update(completed: task_params[:completed])
    respond_to do |format|
      if request.referrer == tasks_url || request.referrer == root_url
        format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@task)}_container") }
        format.html { redirect_to tasks_path, notice: "Updated task status." }
      else
        format.turbo_stream { render :update }
        format.html { redirect_to task_path(@task), notice: "Updated task status." }
      end
    end 
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :category, :priority, :completed)
  end
end
