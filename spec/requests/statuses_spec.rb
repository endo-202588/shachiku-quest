require "rails_helper"

RSpec.describe "Statuses", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  describe "GET /statuses/new" do
    context "when not logged in" do
      it "redirects to login page" do
        get new_status_path

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        log_in(user)
      end

      it "returns http success" do
        get new_status_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  let(:target_date) { Date.current }

  describe "POST /statuses" do
    let(:valid_params) do
      {
        status: {
          status_type: "peaceful", # Status.status_types.keys のいずれか
          memo: "今日は余裕あります",
          status_date: target_date
        }
      }
    end

    context "when not logged in" do
      it "does not create status and redirects to login" do
        expect {
          post statuses_path, params: valid_params
        }.not_to change(Status, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        log_in(user)
      end

      it "creates a status for current_user and redirects" do
        expect {
          post statuses_path, params: valid_params
        }.to change(Status, :count).by(1)

        status = Status.order(:created_at).last
        expect(status.user_id).to eq(user.id)
        expect(status.status_type).to eq("peaceful")

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_task_path)
      end

      it "renders errors when params are invalid" do
        invalid_params = {
          status: {
            status_type: nil,
            memo: ""
          }
        }

        expect {
          post statuses_path, params: invalid_params
        }.not_to change(Status, :count)

        # バリデーションエラー時に new を描画する想定
        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      end
    end
  end
end
