import Player from "./player";
import store from "../store";
import {setPlayingTime} from "../store/reducerCreator.ts";

let globalAudioPlayer;

export function playAudio(src: string) {
    stopAudio();
    destroyAudio();
    globalAudioPlayer = Player({
        source: src,
        cors: true,
    })
        .create()
        .update(function (currentTime: number, duration: number) {
            store.dispatch(setPlayingTime(currentTime));
        })
        .ready(
            function () {
                globalAudioPlayer.play();
            }
        );
}

export function stopAudio() {
    if (globalAudioPlayer) {
        globalAudioPlayer.stop();
    }
}

export function destroyAudio() {
    if (globalAudioPlayer) {
        globalAudioPlayer.destroy();
    }
}