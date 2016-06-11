import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let name = this.getQueryParams()["name"]
    let channel = socket.channel("play", {name: name})

    $(".tap").on("click", event => {
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

  getQueryParams()
  {
    let params = []
    let hashes = document.location.search.slice(1).split("&")
    for(let i = 0; i < hashes.length; i++)
    {
      let hash = hashes[i].split("=")
      params.push(hash[0])
      params[hash[0]] = hash[1]
    }
    return params
  }
}
