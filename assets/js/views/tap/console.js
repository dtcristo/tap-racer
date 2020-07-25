import MainView from "../main";
import socket from "../../socket";
import Stopwatch from "../../stopwatch";

export default class TapConsoleView extends MainView {
  mount() {
    super.mount();

    this.maxScore = 150;
    this.stopwatch = new Stopwatch(document.querySelector(".stopwatch"));

    let channel = socket.channel("console", {});

    channel.on("user_join", (payload) => {
      this.handleJoin(payload["name"], payload["user_id"]);
    });

    channel.on("user_terminate", (payload) => {
      this.handleTerminate(payload["user_id"]);
    });

    channel.on("user_tap", (payload) => {
      this.handleJoin(payload["name"], payload["user_id"]);
      if (this.gameLive) {
        this.handleTap(payload["user_id"]);
      }
    });

    channel
      .join()
      .receive("ok", (resp) => {
        console.log("Joined 'console' channel", resp);
      })
      .receive("error", (resp) => {
        console.log("Error joining 'console' channel", resp);
      });

    $("#start").on("click", (event) => {
      this.stopGame();
      this.clearGame();
      this.startGame();
    });

    console.log("TapConsoleView mounted");
  }

  unmount() {
    super.unmount();
    console.log("TapConsoleView unmounted");
  }

  handleJoin(name, userId) {
    console.log("Join: " + name);
    if (this.getPlayer(userId).length === 0) {
      this.addPlayer(name, userId);
    }
  }

  handleTerminate(userId) {
    console.log("Terminate: " + this.getName(userId));
    this.getPlayer(userId).remove();
  }

  handleTap(userId) {
    let name = this.getName(userId);
    console.log("Tap: " + name);
    let $player = this.getPlayer(userId);
    if ($player.length === 1) {
      let score = this.getScore($player);
      score++;
      this.setScore($player, score);
      if (score === this.maxScore) {
        this.stopGame();
        alert(`${name} wins!`);
      }
    }
  }

  getPlayer(userId) {
    return $(`.player[data-user-id="${userId}"]`);
  }

  getName(userId) {
    return $(`.player[data-user-id="${userId}"] .player-name`).text();
  }

  addPlayer(name, userId) {
    $(".players").append(`
      <div class="player" data-user-id="${userId}">
        <b class="player-name">${name}</b>
        <div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
        </div>
      </div>
    `);
  }

  stopGame() {
    this.stopwatch.stop();
    this.gameLive = false;
  }

  clearGame() {
    $(".progress-bar").attr("aria-valuenow", "0").attr("style", "width: 0%;");
    this.stopwatch.reset();
    this.stopwatch.print();
  }

  startGame() {
    this.flashMessage("Get ready");
    window.setTimeout(() => {
      this.flashMessage("3");
    }, 1000);
    window.setTimeout(() => {
      this.flashMessage("2");
    }, 2000);
    window.setTimeout(() => {
      this.flashMessage("1");
    }, 3000);
    window.setTimeout(() => {
      this.flashMessage("Tap!");
      this.stopwatch.start();
      this.gameLive = true;
      console.log("gameLive = true");
    }, 4000);
  }

  getScore($player) {
    return parseInt($player.find(".progress-bar").attr("aria-valuenow"));
  }

  setScore($player, score) {
    $player
      .find(".progress-bar")
      .attr("aria-valuenow", score)
      .attr("style", `width: ${score / (this.maxScore / 100)}%;`);
  }

  flashMessage(message) {
    $(".message").text(message).fadeTo(0, 100).fadeTo(1000, 0);
  }
}
