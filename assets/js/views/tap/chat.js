import MainView from "../main"
import socket from "../../socket"

export default class TapChatView extends MainView {
  mount() {
    super.mount()

    let name = window.prompt("What is your name?") || "Anonymous"
    let room = $("#messages").data("room")
    let channel = socket.channel(`chat:${room}`, {name: name})

    channel.on("new_msg", payload => {
      let text = payload["text"],
          name = payload["name"]
      this.renderMessage(name, text)
    })

    channel.join()
      .receive("ok", resp => {
        console.log(`Joined 'chat:${room}' channel`, resp)
      })
      .receive("error", resp => {
        console.log(`Error joining 'chat:${room}' channel`, resp)
        alert(`Error joining channel. Reason: ${resp}`)
      })

    $('form').submit(event => {
      event.preventDefault()
      let text = $('#text').val()
      if (text !== '') {
        channel.push("new_msg", {text: text})
      }
      $('#text').val('').focus()
    })

    $('#text').focus()
    console.log("TapChatView mounted")
  }

  unmount() {
    super.unmount()
    console.log("TapChatView unmounted")
  }

  renderMessage(name, text) {
    let messageHtml = `<p><b>${name}:</b> ${text}</p>`
    $(messageHtml).appendTo('#messages').effect('highlight')
    $('#messages').scrollTop($('#messages').prop('scrollHeight'))
  }
}
