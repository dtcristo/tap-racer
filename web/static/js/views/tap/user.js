import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let channel = socket.channel("taps:user", {})
    let $tapButton = $(".tap")
    let username = $tapButton.data("username")

    $tapButton.on("click", event => {
      console.log("tap")
      channel.push("tap", {username: username})
    })

    channel.join()
      .receive("ok", resp => {
        console.log("Joined taps:user", resp)
      })
      .receive("error", resp => {
        console.log("Error joining taps:user", resp)
      })

    console.log("TapUserView mounted")
  }

  unmount() {
    super.unmount()

    // Specific logic here
    console.log("TapUserView unmounted")
  }
}
