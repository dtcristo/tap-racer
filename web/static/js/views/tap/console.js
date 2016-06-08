import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let channel = socket.channel("taps:console", {})

    channel.on("tap", payload => {
      console.log(payload)
    })

    channel.join()
      .receive("ok", resp => {
        console.log("Joined taps:console", resp)
      })
      .receive("error", resp => {
        console.log("Error joining taps:console", resp)
      })

    console.log("TapConsoleView mounted")
  }

  unmount() {
    super.unmount()

    // Specific logic here
    console.log("TapConsoleView unmounted")
  }
}
