# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge(sender: current_user))

    if @message.save
      ConversationChannel.broadcast_to(
        @conversation,
        render_to_string(partial: "messages/message", locals: { message: @message })
      )
    end

    head :ok   # ←←← IMPORTANT: no redirect, no render
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
