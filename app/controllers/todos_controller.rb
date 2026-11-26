class TodosController < ApplicationController
  before_action :set_todo, only: [ :show, :edit, :update, :destroy ]

  def index
    @pending_todos = Current.user.todos.where(status: "pending")
    @completed_todos = Current.user.todos.where(status: "completed")
    @cancelled_todos = Current.user.todos.where(status: "cancelled")
  end

  def new
    @todo = Current.user.todos.new
  end

  def create
    @todo = Current.user.todos.new(todo_params)

    if @todo.save
      redirect_to todos_path, notice: "Todo created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "Todo deleted successfully."
  end

  private

  def set_todo
    @todo = Current.user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :status)
  end
end
