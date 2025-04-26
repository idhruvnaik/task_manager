class TaskController < ApplicationController
  before_action :validate_user
  before_action :check_rate_limit, only: [:create]

  def create
    unless validate_params(["title", "description"])
      return
    end

    begin
      task = nil
      ActiveRecord::Base.transaction do
        task = Task.create!(title: params[:title], description: params[:description], status: :pending, user_id: @user.id)
      end

      render_success(task, "Profile created", :created) and return
    rescue => error
      render_failure({}, error.message, :internal_server_error) and return
    end
  end

  def list
    unless validate_params(["status"])
      return
    end

    begin
      tasks = Task.where(user_id: @user.id)
      tasks = tasks.where(status: params[:status]) if params[:status].present?
      tasks = tasks.order(created_at: :desc)
      tasks = tasks.paginate(page: params[:page], per_page: 1)

      data = { tasks: tasks, meta: { current_page: tasks.current_page, per_page: tasks.per_page, total_entries: tasks.total_entries, total_pages: tasks.total_pages } }

      render_success(data, "Success !!", :ok) and return
    rescue => error
      render_failure({}, error.message, :internal_server_error) and return
    end
  end
end
