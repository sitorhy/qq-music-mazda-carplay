export default function songListReducer(state: {
    dissId: string;
    albumCoverUrl: string;
    description: string;
    songList: Song[];
    title: string;
} = {
    dissId: '',
    albumCoverUrl: '',
    description: '',
    songList: [],
    title: ''
}, action: {
    type: string;
    songList?: Song[];
    albumName: string;
    albumDesc: string;
} = {
    type: '',
    albumName: '',
    albumDesc: ''
}) {
    switch (action.type) {
        case 'SET_SONG_LIST':
        {
            return {
                ...state,
                albumName: action.albumName,
                albumCoverUrl: action.albumCoverUrl,
                albumDesc: action.albumDesc,
                songList: Array.isArray(action.songList) ? action.songList : [],
            }
        }
    }

    return state;
}