module TaskService
  class Manager
    def initialize(user)
      @user = user
    end

    def list(status = nil, page = 1, per_page = 1)
      begin
        tasks = Task.where(user_id: @user.id)
        tasks = tasks.where(status: status) if status.present?
        tasks = tasks.order(created_at: :desc)
        tasks = tasks.paginate(page: page, per_page: per_page)

        serialized_tasks = tasks.map { |task| TaskSerializer.new(task) }

        data = { tasks: serialized_tasks, meta: { current_page: tasks.current_page, per_page: tasks.per_page, total_entries: tasks.total_entries, total_pages: tasks.total_pages } }
      rescue => error
        Rails.logger.error("[TaskService::Manager] Error listing tasks: #{error.message}")
        Rails.logger.error(error.backtrace.join("\n"))

        raise error
      end
    end

    def create(title, description)
      begin
        task = nil
        ActiveRecord::Base.transaction do
          task = Task.create!(title: title, description: description, status: :pending, user_id: @user.id)
        end

        return task
      rescue => error
        Rails.logger.error("[TaskService::Manager] Error creating tasks: #{error.message}")
        Rails.logger.error(error.backtrace.join("\n"))

        raise error
      end
    end
  end
end
