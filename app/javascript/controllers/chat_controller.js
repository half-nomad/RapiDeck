import { Controller } from "@hotwired/stimulus"

// 채팅 메시지 자동 스크롤 컨트롤러
export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
  }

  messagesTargetConnected() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  // 메시지 전송 후 스크롤
  afterMessageSent() {
    setTimeout(() => this.scrollToBottom(), 100)
  }
}
