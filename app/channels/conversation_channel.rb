# app/channels/conversation_channel.rb
class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find_by(id: params[:conversation_id])

    if @conversation.nil?
      reject
      return
    end

    # Security check (now works because of the Connection above)
    unless @conversation.user1_id == current_user.id || @conversation.user2_id == current_user.id
      reject
      return
    end

    stream_for @conversation
    Rails.logger.info "✅ User #{current_user.id} subscribed to conversation #{@conversation.id}"
  end

  def unsubscribed
    # cleanup if needed
  end
end
