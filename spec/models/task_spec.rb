require "rails_helper"
RSpec.describe Task, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password123") }

  it "is valid with title, status and user" do
    task = Task.new(title: "Sample Task", status: "pending", user: user)
    expect(task).to be_valid
  end

  it "is invalid without a title" do
    task = Task.new(status: "pending", user: user)
    expect(task).not_to be_valid
    expect(task.errors[:title]).to include("can't be blank")
  end

  it "defaults to non-archived tasks due to default_scope" do
    archived_task = Task.create!(title: "Archived Task", status: "archived", user: user)
    non_archived_task = Task.create!(title: "Active Task", status: "pending", user: user)

    expect(Task.all).to include(non_archived_task)
    expect(Task.all).not_to include(archived_task)
  end

  it "can retrieve archived tasks" do
    archived_task = Task.create!(title: "Archived Task", status: "archived", user: user)
    expect(Task.archived).to include(archived_task)
  end
end
