import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let $tapButton = $(".tap")
    let name = $tapButton.data("name")
    let channel = socket.channel("play", {name: name})

    $tapButton.on("click", event => {
      console.log("tap")
      channel.push("tap")
    })

    channel.join()
      .receive("ok", resp => {
        console.log("Joined 'play' channel", resp)
      })
      .receive("error", resp => {
        console.log("Error joining 'play' channel", resp)
      })

    console.log("TapPlayView mounted")
  }

  unmount() {
    super.unmount()
    // Specific logic here
    console.log("TapPlayView unmounted")
  }
}
