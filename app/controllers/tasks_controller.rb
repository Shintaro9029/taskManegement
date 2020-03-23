class TasksController < ApplicationController
  def index
    keywords = params.dig(:q, :keywords_cont_all)&.split(/[[:space:]]/)
    params[:q][:keywords_cont_all] = keywords if keywords
    @q = Task.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    task = Task.create!(task_params)
    redirect_to task, notice: "タスク「#{task.title}」を登録しました。"
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    redirect_to task, notice: "タスク「#{task.title}」を更新しました。"
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.title}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :important, :status, :deadline_date)
  end

  def search_params
    params.require(:q).permit!
  end

end
