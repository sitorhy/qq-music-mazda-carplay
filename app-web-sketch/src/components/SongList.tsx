import {connect} from "react-redux";
import {Grid, NavBar, Image, Ellipsis, List} from "antd-mobile";
import {useNavigate, useSearchParams} from "react-router-dom";

import coverSrc from '../assets/react.svg';
import '../style/SongList.css';
import {useEffect, useRef} from "react";
import {loadPlayingSong, loadSongList, loadSongLyricText} from "../store/reducerCreator.ts";
import {formatInterval} from "../utils";

function SongList(
    props: {
        songList: {
            dissId?: string;
            albumCoverUrl?: string;
            albumDesc?: string;
            songList?: Song[];
            albumName?: string;
            loadSongList?: (dissId: string) => void;
            loadPlayingSong?: (song: Song) => Promise<void>;
            loadSongLyricText?: (song: Song) => Promise<void>;
        },
        playingSong: {
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
    }
) {
    const init = useRef(false);
    const navigate = useNavigate();
    const [searchParams] = useSearchParams();

    const {
        albumName,
        songList = [],
        albumCoverUrl,
        albumDesc
    } = props.songList;

    const playingSong = props.playingSong;

    function onBack() {
        navigate(-1);
    }

    useEffect(() => {
        if (!init.current) {
            if (props.loadSongList) {
                props.loadSongList(searchParams.get('dissId'));
            }
        }
        init.current = true;
    }, []);

    return (
        <div className={'songList'}>
            <div>
                <NavBar back='返回' onBack={onBack}>
                    {albumName}
                </NavBar>
            </div>
            <div className={'content'}>
                <Grid columns={8}>
                    <Grid.Item span={2}>
                        <div className={'cover'}>
                            <Image style={{ borderRadius: 8 }} src={albumCoverUrl || coverSrc} width={150} height={150} fit='fill' />
                            <Ellipsis direction='end' content={albumDesc || ''} />
                        </div>
                    </Grid.Item>

                    <Grid.Item span={6}>
                        <div className={'list'}>
                            <List>
                                {
                                    songList.map(song => {
                                        return <List.Item
                                            style={playingSong.songMid === song.songMid ? {
                                                backgroundColor: '#b9f4b6'
                                            } : {}}
                                            key={song.songMid}
                                            extra={formatInterval(song.interval)}
                                            description={(song.singers || []).map(i => i.name).join('/ ')}
                                            onClick={async () => {
                                                if (props.loadPlayingSong) {
                                                    await props.loadPlayingSong(song);
                                                    navigate({
                                                        pathname: `/playing`,
                                                    });
                                                    if (props.loadSongLyricText) {
                                                        props.loadSongLyricText(song);
                                                    }
                                                }
                                            }}
                                        >
                                            {song.songName}
                                        </List.Item>
                                    })
                                }
                            </List>
                        </div>
                    </Grid.Item>
                </Grid>
            </div>
        </div>
    );
}

export default connect(function (state: {
    songList: {
        dissId: string;
        albumCoverUrl: string;
        albumDesc: string;
        songList: Song[];
        albumName: string;
    };
    playingSong: {
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
}) {
    return {
        songList: state.songList,
        playingSong: state.playingSong
    };
}, function (dispatch) {
    return {
        loadSongList: (dissId: string) => dispatch(loadSongList(dissId)),
        loadPlayingSong: (song: Song) => dispatch(loadPlayingSong(song)),
        loadSongLyricText: (song: Song) => dispatch(loadSongLyricText(song))
    }
})(SongList);