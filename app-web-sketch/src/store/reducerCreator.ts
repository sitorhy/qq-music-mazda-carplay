import QQMusicAPI from "../api";
import {c} from "vite/dist/node/types.d-aGj9QkWt";
import {playAudio} from "../utils/globalAudioPlayer.ts";

export function loadEntryMetaList() {
    return async (dispatch, getState: () => {
        entry: MetaList
    }, {api}: { api: QQMusicAPI }) => {
        const types = ['NEW_ALBUM', 'NEW_SONG', 'RECOMMEND', 'RECOMMEND_FOR_ME'];
        if (sessionStorage.getItem("metaList")) {
            const metaList = JSON.parse(sessionStorage.getItem("metaList"));
            dispatch({
                type: 'SET_ENTRY_META_LIST',
                metaList: metaList.filter((i: Meta) => {
                    return i.categoryTypes.findIndex(type => {
                        return types.includes(type);
                    }) >= 0;
                }),
            });
            return;
        }
        const res = await api.getCategoryList();
        const metaList = res.data.data;
        sessionStorage.setItem("metaList", JSON.stringify(metaList));
        dispatch({
            type: 'SET_ENTRY_META_LIST',
            metaList: metaList.filter((i: Meta) => {
                return i.categoryTypes.findIndex(type => {
                    return types.includes(type);
                }) >= 0;
            }),
        });
    }
}

export function loadMusicHallMetaList() {
    return async (dispatch, getState: () => {
        musicHall: MetaList
    }, {api}: { api: QQMusicAPI }) => {
        const types = ['TOP_LIST'];
        if (sessionStorage.getItem("metaList")) {
            const metaList = JSON.parse(sessionStorage.getItem("metaList"));
            dispatch({
                type: 'SET_MUSIC_HALL_META_LIST',
                metaList: metaList.filter((i: Meta) => {
                    return i.categoryTypes.findIndex(type => {
                        return types.includes(type);
                    }) >= 0;
                }),
            });
            return;
        }
        const res = await api.getCategoryList();
        const metaList = res.data.data;
        sessionStorage.setItem("metaList", JSON.stringify(metaList));
        dispatch({
            type: 'SET_MUSIC_HALL_META_LIST',
            metaList: metaList.filter((i: Meta) => {
                return i.categoryTypes.findIndex(type => {
                    return types.includes(type);
                }) >= 0;
            }),
        });
    }
}

export function loadCollectionMetaList(): {
    type: string;
    metaList: MetaList
} {
    // 我的收藏 全部为固定值
    return {
        type: 'SET_COLLECTION_META_LIST',
        metaList: [
            {
                title: '我喜欢',
                categoryTypes: ['MY_FAV_SONGS', 'MY_FAV_ALBUM', 'MY_FAV_PUB'],
                categories: [
                    {
                        categoryType: 'MY_FAV_SONGS',
                        categoryCode: '0', // 随意
                        categoryName: '歌曲',
                        groupId: '0',
                        groupName: '歌曲',
                        albums: [],
                        songs: [],
                        total: 0,
                        pageNo: 0,
                        pageSize: 0,
                        loading: false,
                    },
                    {
                        categoryType: 'MY_FAV_ALBUM',
                        categoryCode: '1', // 随意
                        categoryName: '歌单',
                        groupId: '1',
                        groupName: '歌单',
                        albums: [],
                        songs: [],
                        total: 0,
                        pageNo: 0,
                        pageSize: 0,
                        loading: false,
                    },
                    {
                        categoryType: 'MY_FAV_PUB',
                        categoryCode: '2', // 随意
                        categoryName: '专辑',
                        groupId: '2',
                        groupName: '专辑',
                        albums: [],
                        songs: [],
                        total: 0,
                        pageNo: 0,
                        pageSize: 0,
                        loading: false,
                    }
                ]
            },
            {
                title: '创建的歌单',
                categoryTypes: ['MY_DIR'],
                categories: [
                    {
                        categoryType: 'MY_DIR',
                        categoryCode: '3', // 随意
                        categoryName: '创建的歌单',
                        groupId: '3',
                        groupName: '创建的歌单',
                        albums: [],
                        songs: [],
                        total: 0,
                        pageNo: 0,
                        pageSize: 0,
                        loading: false,
                    },
                ]
            }
        ]
    };
}

async function loadSelfCategoryDetail(
    category: Category,
    dispatch: (action: Record<string, unknown>) => void,
    getState: () => {
        collection: {
            metaList: MetaList
        },
    }, {api}: { api: QQMusicAPI }) {
    switch (category.categoryType) {
        case 'MY_FAV_SONGS': {
            const res = await api.getMyAlbumList();
            const albums = res.data.data.filter((i) => {
                // 我喜欢
                return i.dirId === 201;
            });
            if (albums.length > 0) {
                const myFavSongsAlbum = albums[0];
                const res = await api.getSongs({
                    resId: myFavSongsAlbum.dissId
                });
                const songs = res.data.data;
                dispatch({
                    type: 'SET_COLLECTION_CATEGORY',
                    categoryType: category.categoryType,
                    categoryCode: category.categoryCode,
                    songs
                });
            }
        }
            break;
        case 'MY_FAV_ALBUM': {
            const res = await api.getFavAlbumList();
            const albums = res.data.data;
            dispatch({
                type: 'SET_COLLECTION_CATEGORY',
                categoryType: category.categoryType,
                categoryCode: category.categoryCode,
                albums
            });
        }
            break;
        case 'MY_FAV_PUB': {
            const res = await api.getMyFavPubList();
            const albums = res.data.data;
            dispatch({
                type: 'SET_COLLECTION_CATEGORY',
                categoryType: category.categoryType,
                categoryCode: category.categoryCode,
                albums
            });
        }
            break;
        case 'MY_DIR': {
            const res = await api.getMyAlbumList();
            const albums = res.data.data.filter((i) => i.dirId !== 201);
            dispatch({
                type: 'SET_COLLECTION_CATEGORY',
                categoryType: category.categoryType,
                categoryCode: category.categoryCode,
                albums
            });
        }
            break;
    }
}

export function loadNextCategoryDetail(category: Category) {
    return async (
        dispatch: (action: Record<string, unknown>) => void,
        getState: () => {
            entry: {
                metaList: MetaList
            },
            musicHall: {
                metaList: MetaList
            },
        }, {api}: { api: QQMusicAPI }) => {
        const state = getState();
        let metaList;
        let submitActionType = '';
        switch (category.categoryType) {
            case "NEW_ALBUM":
            case "NEW_SONG":
            case "RECOMMEND":
            case "RECOMMEND_FOR_ME": {
                metaList = state.entry.metaList;
                submitActionType = 'SET_ENTRY_CATEGORY';
            }
                break;
            case "TOP_LIST": {
                metaList = state.musicHall.metaList;
                submitActionType = 'SET_MUSIC_HALL_CATEGORY';
            }
                break;
            case 'MY_FAV_SONGS':
            case 'MY_FAV_ALBUM':
            case 'MY_FAV_PUB':
            case 'MY_DIR': {
                // 转交我的模块处理
                return loadSelfCategoryDetail(category, dispatch, getState, {api});
            }
            default:
                return;
        }
        const metaIndex = metaList.findIndex(
            (i) => i.categoryTypes.includes(category.categoryType)
        );
        const meta = metaList[metaIndex];
        if (metaIndex >= 0) {
            const find: Category | undefined = meta.categories.find((i) => i.categoryCode === category.categoryCode);
            if (find) {
                if ((find.albums?.length || find.songs?.length) && find.total === (find.albums?.length || find.songs?.length)) {
                    return;
                }
            } else {
                return;
            }
        }

        const res = await api.getCategoryDetail({
            pageNo: (category.pageNo || 0) + 1,
            pageSize: category.pageSize || 20,
            code: category.categoryCode,
            type: category.categoryType
        });

        dispatch({
            type: submitActionType,
            ...res.data.data
        })
    }
}

export function setTagPopupVisible(visible: boolean) {
    return {
        type: 'SET_TAG_POPUP_VISIBILITY',
        visible: visible
    }
}

export function loadPopupCategoryDetail(category: Category) {
    return async (
        dispatch: (action: Record<string, unknown>) => void,
        getState: () => {
            tagPopup: {
                visible: boolean;
                groups: CategoryPopupGroup[];
            },
        }, {api}: { api: QQMusicAPI }
    ) => {
        let metaList;
        if (sessionStorage.getItem("metaList")) {
            metaList = JSON.parse(sessionStorage.getItem("metaList"));
        } else {
            const res = await api.getCategoryList();
            metaList = res.data.data;
            sessionStorage.setItem("metaList", JSON.stringify(metaList));
        }

        const meta = metaList.find((i: Meta) => i.categoryTypes.includes(category.categoryType));
        if (meta) {
            const groups = meta.categories.reduce((acc: CategoryPopupGroup[], cur: Category) => {
                let group = acc.find(a => (a.groupId || '') === cur.groupId);
                if (!group) {
                    group = {
                        groupName: cur.groupName || '',
                        groupId: cur.groupId || '',
                        categories: [{
                            ...cur
                        }]
                    };
                    acc.push(group);
                } else {
                    group.categories.push({...cur});
                }
                return acc;
            }, []);

            dispatch({
                type: 'SET_TAG_POPUP_GROUPS',
                groups
            });
        }

    }
}

export function loadSongList(dissId: string) {
    return async (
        dispatch: (action: Record<string, unknown>) => void,
        getState: () => {
            songList: {
                dissId: '',
                albumCoverUrl: '',
                albumDesc: '',
                songList: [],
                title: ''
            },
        }, {api}: { api: QQMusicAPI }
    ) => {
        const res = await api.getSongs({
            resId: dissId
        });
        const songs = res.data.data;
        dispatch({
            type: 'SET_SONG_LIST',
            songList: songs,
            albumCoverUrl: songs[0].albumCoverUrl,
            albumDesc: songs[0].albumDesc,
            albumName: songs[0].dissName
        });
    }
}

export function setPlayingTime(currentTime: number) {
    return {
        type: 'UPDATE_CURRENT_TIME',
        currentTime
    }
}

export function loadPlayingSong(song: Song) {
    return async (
        dispatch: (action: Record<string, unknown>) => void,
        getState: () => {
            playingSong:  {
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
            }
        },
        {api}: { api: QQMusicAPI }
    ) => {
        const state = getState();
        const res = await api.getSongSource({
            songMid: song.songMid
        });
        const sourceRes: { data: SongSource } = res.data;
        if (song.songMid !== state.playingSong.songMid) {
            setTimeout(() => {
               playAudio(sourceRes.data.url);
            });
        }
        dispatch({
            type: 'UPDATE_SONG',
            songMid: song.songMid,
            interval: song.interval,
            currentTime: 0,
            songUrl: sourceRes.data.url,
            albumCoverUrl: song.albumCoverUrl,
            songName: song.songName,
            singers: song.singers,
        });
    }
}

export function loadSongLyricText(song: Song) {
    return async (
        dispatch: (action: Record<string, unknown>) => void,
        getState: () => {
            playingSong:  {
                interval: number;
                currentTime: number;
                songUrl: string;
                albumCoverUrl: string;
                songName: string;
                singers?: {
                    name: string;
                }[];
                lyricText: string;
            }
        },
        {api}: { api: QQMusicAPI }
    ) => {
        const lyricRes: { data: { data: string } } = await api.getSongLyric({
            songMid: song.songMid
        });
        dispatch({
            type: 'UPDATE_LYRIC_TEXT',
            lyricText: lyricRes.data.data
        });
    }
}