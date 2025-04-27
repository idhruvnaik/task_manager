class TaskController < ApplicationController
  before_action :validate_user
  before_action :check_rate_limit, only: [:create]
  before_action :sanitize_parameters

  def create
    unless validate_params(["title", "description"])
      return
    end

    begin
      instance = TaskService::Manager.new(@user)
      response = instance.create(params[:title], params[:description])

      render_success(response, "Task created !!", :created) and return
    rescue => error
      render_failure({}, error.message, :internal_server_error) and return
    end
  end

  def list
    unless validate_params(["status"])
      return
    end

    begin
      instance = TaskService::Manager.new(@user)
      response = instance.list()

      render_success(response, "Success !!", :ok) and return
    rescue => error
      render_failure({}, error.message, :internal_server_error) and return
    end
  end

  def archive
    unless validate_params(["id"])
      return
    end

    begin
      task = Task.find_by_id params[:id]
      if task.nil?
        render_failure({}, "Task is missing !!") and return
      end

      ActiveRecord::Base.transaction do
        task.update(status: :archived)
      end

      render_success(task, "Success !!", :ok) and return
    rescue => error
      render_failure({}, error.message, :internal_server_error) and return
    end
  end

  private

  def sanitize_parameters
    params.slice!(:title, :description, :status, :reminder_date, :completion_date)
  end
end
