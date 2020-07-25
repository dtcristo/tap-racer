import MainView from "../main";
import socket from "../../socket";

export default class TapPlayView extends MainView {
  mount() {
    super.mount();

    let name = window.prompt("What is your name?") || "Anonymous";
    let channel = socket.channel("play", { name: name });

    $(".tap").on("click touchstart", (event) => {
      console.log("tap");
      channel.push("tap");
    });

    channel
      .join()
      .receive("ok", (resp) => {
        console.log("Joined 'play' channel", resp);
      })
      .receive("error", (resp) => {
        console.log("Error joining 'play' channel", resp);
      });

    console.log("TapPlayView mounted");
  }

  unmount() {
    super.unmount();
    console.log("TapPlayView unmounted");
  }
}
