require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:password) { "password" }

  let(:user) do
    create(
      :user,
      password: password,
      password_confirmation: password
    )
  end

  describe "GET /users" do
    context "when not logged in" do
      it "redirect to login" do
        get users_path

        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in and status exist" do
      before do
        log_in(user)
        create(:status, user: user)
      end

      it "returns http success" do
        get users_path

        expect(response).to have_http_status(:ok).or have_http_status(:success)
      end

      it "shows the user list (includes current user's full_name)" do
        get users_path

        expect(response.body).to include(user.decorate.full_name)
      end
    end

    context "when logged in but status dose not exist" do
      before do
        log_in(user)
      end

      it "redirects to new status page" do
        get users_path

        expect(response).to redirect_to(new_status_path(date: Date.current))
      end
    end

    context "when logged in and status exists" do
      before do
        log_in(user)
        create(:status, user: user)
      end

      it "returns http success" do
        get introduction_path(user)

        expect(response).to have_http_status(:ok).or have_http_status(:success)
      end

      it "show the users's introduction" do
        get introduction_path(user)

        expect(response.body).to include(user.decorate.full_name)
        expect(response.body).to include(user.department)
        expect(response.body).to include(user.decorate.virtue_rank_badge)
        expect(response.body).to include(user.decorate.total_virtue_points_badge)
      end
    end
  end
end
