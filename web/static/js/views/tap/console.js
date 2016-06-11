import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let channel = socket.channel("console", {})

    channel.on("join", payload => {
      this.handleJoin(payload["name"], payload["user_id"])
    })
    channel.on("terminate", payload => {
      this.handleTerminate(payload["user_id"])
    })
    channel.on("tap", payload => {
      if (this.gameLive) {
        this.handleTap(payload["user_id"])
      }
    })
    channel.join()
      .receive("ok", resp => {
        console.log("Joined 'console' channel", resp)
      })
      .receive("error", resp => {
        console.log("Error joining 'console' channel", resp)
      })

    this.resetGame()
    console.log("TapConsoleView mounted")
  }

  unmount() {
    super.unmount()
    // Specific logic here
    console.log("TapConsoleView unmounted")
  }

  handleJoin(name, userId) {
    console.log("Join: " + name)
    if (this.getPlayer(userId).length === 0) {
      this.addPlayer(name, userId, 0)
    }
  }

  handleTerminate(userId) {
    console.log("Terminate: " + this.getName(userId))
    this.getPlayer(userId).remove()
  }

  handleTap(userId) {
    let name = this.getName(userId)
    console.log("Tap: " + name)
    let $player = this.getPlayer(userId)
    if ($player.length === 1) {
      let score = this.getScore($player)
      score++
      this.setScore($player, score)
      if (score === 10) {
        this.gameLive = false
        console.log("gameLive = false")
        console.log(`${name} wins!`)
        this.resetGame()
      }
    }
  }

  getPlayer(userId) {
    return $(`.player[data-user-id="${userId}"]`)
  }

  getName(userId) {
    return $(`.player[data-user-id="${userId}"] .player-name`).text()
  }

  addPlayer(name, userId) {
    $(".players").append(`
      <div class="player" data-user-id="${userId}">
        <h2 class="player-name">${name}</h2>
        <div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
        </div>
      </div>
    `)
  }

  resetGame() {
    $(".progress-bar").attr("aria-valuenow", "0")
                      .attr("style", "width: 0%;")

    window.setTimeout(() => { console.log("3") }, 1000);
    window.setTimeout(() => { console.log("2") }, 2000);
    window.setTimeout(() => { console.log("1") }, 3000);

    window.setTimeout(() => {
      console.log("Go!")
      this.gameLive = true
      console.log("gameLive = true")
    }, 4000);
  }

  getScore($player) {
    return parseInt($player.find(".progress-bar").attr("aria-valuenow"))
  }

  setScore($player, score) {
    $player.find(".progress-bar").attr("aria-valuenow", score)
                                 .attr("style", `width: ${score}%;`)
  }
}
