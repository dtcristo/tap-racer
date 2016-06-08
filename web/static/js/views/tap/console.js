import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let channel = socket.channel("console", {})

    channel.on("join", payload => {
      console.log("Join: " + payload["username"])
    })

    channel.on("terminate", payload => {
      console.log("Terminate: " + payload["username"])
    })

    channel.on("tap", payload => {
      console.log("Tap: " + payload["username"])
    })

    channel.join()
      .receive("ok", resp => {
        console.log("Joined 'console' channel", resp)
      })
      .receive("error", resp => {
        console.log("Error joining 'console' channel", resp)
      })

    console.log("TapConsoleView mounted")
  }

  unmount() {
    super.unmount()

    // Specific logic here
    console.log("TapConsoleView unmounted")
  }
}
