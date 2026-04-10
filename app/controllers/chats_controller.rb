# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @other_user = User.find_by(id: params[:user_id])
    unless @other_user
      redirect_to root_path, alert: "User not found."
      return
    end

    if @other_user == current_user
      redirect_to root_path, alert: "You cannot chat with yourself."
      return
    end

    @conversation = Conversation.find_or_create_between(current_user, @other_user)
    @messages = @conversation.messages.order(:created_at)
    @message = Message.new
  end
end
