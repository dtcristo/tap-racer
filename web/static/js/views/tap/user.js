import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let $tapButton = $(".tap")
    let username = $tapButton.data("username")
    let channel = socket.channel("user", {username: username})

    $tapButton.on("click", event => {
      console.log("tap")
      channel.push("tap")
    })

    channel.join()
      .receive("ok", resp => {
        console.log("Joined 'user' channel", resp)
      })
      .receive("error", resp => {
        console.log("Error joining 'user' channel", resp)
      })

    console.log("TapUserView mounted")
  }

  unmount() {
    super.unmount()

    // Specific logic here
    console.log("TapUserView unmounted")
  }
}
