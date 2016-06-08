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

  addPlayer(username, score) {
    $(".players").append(`<div class="player" data-username="${username}"><div class="player-username">${username}</div><div class="player-score">0</div></div>`)
  }

  resetGame() {
    $(".player-score").text("0")
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
      let score = parseInt($player.find(".player-score").text())
      score++
      $player.find(".player-score").text(score)
      if (score === 100) {
        alert(`${username} wins!`)
        this.resetGame()
      }
    }
  }
}
