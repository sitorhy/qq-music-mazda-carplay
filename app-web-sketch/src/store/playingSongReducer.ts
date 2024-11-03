import testDefaultCover from "../assets/空气蛹_INSIDE_专辑封面.webp";
import testDefaultSong from "../assets/testSong.json";

export default function playingSongReducer(state: {
    interval: number;
    currentTime: number;
    songUrl: string;
    albumCoverUrl: string;
    songName: string;
    songMid: string;
    singers?: {
        name: string;
    }[];
    lyricText: string;
} = {
    interval: testDefaultSong.interval,
    currentTime: 0,
    songUrl: '',
    albumCoverUrl: testDefaultCover,
    songName: testDefaultSong.songName,
    lyricText: testDefaultSong.lyricText,
    singers: testDefaultSong.singers,
    songMid: '',
}, action: {
    type: string;
    interval?: number;
    currentTime?: number;
    songUrl?: string;
    albumCoverUrl?: string;
    songName?: string;
    singers?: {
        name: string;
    }[];
    songMid: string;
    lyricText: string;
}) {
    switch (action.type) {
        case 'UPDATE_CURRENT_TIME': {
            return {
              ...state,
              currentTime: action.currentTime,
            };
        }
        case 'UPDATE_SONG': {
            return {
                ...state,
                interval: action.interval,
                currentTime: action.currentTime,
                songUrl: action.songUrl,
                albumCoverUrl: action.albumCoverUrl,
                songName: action.songName,
                singers: action.singers,
                lyricText: action.lyricText || '',
                songMid: action.songMid,
            };
        }
        case 'UPDATE_LYRIC_TEXT': {
            return {
                ...state,
                lyricText: action.lyricText,
            };
        }
    }
    return state;
}