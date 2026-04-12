# spec/controllers/messages_controller_spec.rb
require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:sender) do
    User.create!(
      username: "test_sender",
      college: "Test University",
      email: "sender@example.com",
      password: "password123",
      admin: false
    )
  end

  let(:recipient) do
    User.create!(
      username: "test_recipient",
      college: "Test University",
      email: "recipient@example.com",
      password: "password123",
      admin: false
    )
  end

  let(:conversation) do
    Conversation.create!(
      user1_id: sender.id,
      user2_id: recipient.id
    )
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in sender
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        conversation_id: conversation.id,
        message: { content: "This is a test message" }
      }
    end

    context "with valid parameters" do
      it "creates a new message belonging to the conversation and sender" do
        expect do
          post :create, params: valid_params
        end.to change(Message, :count).by(1)

        message = Message.last
        expect(message.content).to eq("This is a test message")
        expect(message.conversation).to eq(conversation)
        expect(message.sender).to eq(sender)
      end

      it "broadcasts the rendered message partial via ConversationChannel" do
        expect(ConversationChannel).to receive(:broadcast_to).with(
          conversation,
          an_instance_of(String)  # the result of render_to_string(partial: "messages/message")
        )

        post :create, params: valid_params
      end

      it "returns HTTP 200 (head :ok) with no body" do
        post :create, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(response.body).to be_empty
      end

      it "does NOT redirect or render a view (as required by the controller)" do
        post :create, params: valid_params

        expect(response).not_to be_redirect
      end
    end

    context "when the message is invalid (missing content)" do
      let(:invalid_params) do
        {
          conversation_id: conversation.id,
          message: { content: "" }
        }
      end

      it "does NOT create a message" do
        expect do
          post :create, params: invalid_params
        end.not_to change(Message, :count)
      end

      it "does NOT broadcast anything" do
        expect(ConversationChannel).not_to receive(:broadcast_to)

        post :create, params: invalid_params
      end

      it "still returns HTTP 200 (head :ok)" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is not authenticated" do
      before do
        sign_out sender
      end

      it "redirects to the sign-in page (Devise behavior)" do
        post :create, params: valid_params

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the conversation does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect do
          post :create, params: { conversation_id: 999_999, message: { content: "hi" } }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
