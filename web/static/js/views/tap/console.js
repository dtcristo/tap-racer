import MainView from "../main"
import socket from "../../socket"

export default class View extends MainView {
  mount() {
    super.mount()

    let channel = socket.channel("console", {})

    channel.on("join", payload => {
      this.handleJoin(payload["name"])
    })
    channel.on("terminate", payload => {
      this.handleTerminate(payload["name"])
    })
    channel.on("tap", payload => {
      if (this.gameLive) {
        this.handleTap(payload["name"])
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

  getPlayer(name) {
    return $(`.players [data-name="${name}"]`)
  }

  addPlayer(name) {
    $(".players").append(`
      <div class="player" data-name="${name}">
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
      console.log("go")
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

  handleJoin(name) {
    console.log("Join: " + name)
    if (this.getPlayer(name).length === 0) {
      this.addPlayer(name, 0)
    }
  }

  handleTerminate(name) {
    console.log("Terminate: " + name)
    this.getPlayer(name).remove()
  }

  handleTap(name) {
    console.log("Tap: " + name)
    let $player = this.getPlayer(name)
    if ($player.length === 0) {
      this.addPlayer(name, 1)
    }
    else {
      let score = this.getScore($player)
      score++
      this.setScore($player, score)
      if (score === 10) {
        this.gameLive = false
        console.log("gameLive = false")
        alert(`${name} wins!`)
        this.resetGame()
      }
    }
  }
}
