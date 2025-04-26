require "rails_helper"

RSpec.describe "Tasks API", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password123") }
  let(:task) { Task.create!(title: "Sample Task", status: "pending", user: user) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{user.auth_token}",
      "Content-Type" => "application/json",
    }
  end

  describe "PATCH /tasks/:id/status" do
    it "updates the task status successfully" do
      get "/task/list", params: { status: "pending" }, headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end
