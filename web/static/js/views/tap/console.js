import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let channel = socket.channel("console", {})

    channel.on("join", payload => {
      this.handleJoin(payload["username"])
    })
    channel.on("terminate", payload => {
      this.handleTerminate(payload["username"])
    })
    channel.on("tap", payload => {
      this.handleTap(payload["username"])
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

  getPlayer(username) {
    return $(`.players [data-username="${username}"]`)
  }

  addPlayer(username) {
    $(".players").append(`
      <div class="player" data-username="${username}">
        <h2 class="player-username">${username}</h2>
        <div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
        </div>
      </div>
    `)
  }

  resetGame() {
    $(".progress-bar").attr("aria-valuenow", "0")
                      .attr("style", "width: 0%;")
  }

  getScore($player) {
    return parseInt($player.find(".progress-bar").attr("aria-valuenow"))
  }

  setScore($player, score) {
    $player.find(".progress-bar").attr("aria-valuenow", score)
                                 .attr("style", `width: ${score}%;`)
  }

  handleJoin(username) {
    console.log("Join: " + username)
    if (this.getPlayer(username).length === 0) {
      this.addPlayer(username, 0)
    }
  }

  handleTerminate(username) {
    console.log("Terminate: " + username)
    this.getPlayer(username).remove()
  }

  handleTap(username) {
    console.log("Tap: " + username)
    let $player = this.getPlayer(username)
    if ($player.length === 0) {
      this.addPlayer(username, 1)
    }
    else {
      let score = this.getScore($player)
      score++
      this.setScore($player, score)
      if (score === 100) {
        alert(`${username} wins!`)
        this.resetGame()
      }
    }
  }
}
