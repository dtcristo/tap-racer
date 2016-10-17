import MainView from "../main"
import socket from "../../socket"

export default class TapChatView extends MainView {
  mount() {
    super.mount()

    let room = $("#messages").data("room")
    let channel = socket.channel(`chat:${room}`);

    channel.on("new_msg", payload => {
      let text = payload["text"],
          name = payload["name"];
      this.renderMessage(name, text);
    })

    channel.join()
      .receive("ok", resp => {
        console.log(`Joined 'chat:${room}' channel`, resp);
      })
      .receive("error", resp => {
        console.log(`Error joining 'chat:${room}' channel`, resp);
        alert(`Error joining channel. Reason: ${resp}`)
      })

    $('form').submit(event => {
      event.preventDefault();
      let name = $('#name').val();
      let text = $('#text').val();
      if (name === '' || text === '') { return; }

      channel.push("new_msg", {
        name: name,
        text: text
      });

      $('#text').val('');
      $('#text').focus();
    });

    console.log("TapChatView mounted");
  }

  unmount() {
    super.unmount()
    console.log("TapChatView unmounted");
  }

  renderMessage(name, text) {
    let messageHtml = `<p><b>${name}:</b> ${text}</p>`;
    $(messageHtml).appendTo('#messages').effect('highlight');
    $('#messages').scrollTop($('#messages').prop('scrollHeight'));
  }
}
