// app/javascript/controllers/conversation_subscription_controller.js
import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
    static targets = ["messages"]
    static values = {
        conversationId: Number,
        currentUserId: Number   // ←←← new value
    }

    connect() {
        console.log("🔌 ConversationSubscription connected – conversation:", this.conversationIdValue)

        this.subscription = consumer.subscriptions.create(
            { channel: "ConversationChannel", conversation_id: this.conversationIdValue },
            {
                connected: () => console.log("✅ WebSocket connected"),
                disconnected: () => console.log("❌ WebSocket disconnected"),
                received: (data) => {
                    console.log("📨 Received new message via Action Cable")

                    // Insert the HTML (it always arrives as "sender style" – blue right)
                    this.messagesTarget.insertAdjacentHTML("beforeend", data)

                    // ←←← FLIP LOGIC FOR RECIPIENT
                    const newMessageEl = this.messagesTarget.lastElementChild
                    if (newMessageEl) {
                        const senderId = parseInt(newMessageEl.dataset.senderId)
                        const myId = this.currentUserIdValue

                        if (senderId !== myId) {
                            // Flip outer container
                            newMessageEl.classList.remove("justify-end")
                            newMessageEl.classList.add("justify-start")

                            // Flip inner bubble
                            const bubble = newMessageEl.querySelector("div")
                            if (bubble) {
                                bubble.classList.remove("bg-blue-600", "text-white", "rounded-tr-none")
                                bubble.classList.add("bg-white", "text-gray-800", "rounded-tl-none", "shadow-sm")
                            }
                        }
                    }

                    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
                }
            }
        )
    }

    disconnect() {
        if (this.subscription) this.subscription.unsubscribe()
    }
}