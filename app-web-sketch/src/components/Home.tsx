import {Outlet, useNavigate} from 'react-router-dom';
import NavBar from './NavBar.tsx';
import styles from '../style/Home.module.css';
import imgLogo from '../assets/qqmusic.png';
import {Image, ProgressBar} from "antd-mobile";
import TestCoverImg from "../assets/react.svg";
import {useMemo} from "react";
import {connect} from "react-redux";
import {formatInterval} from "../utils";

function Home(props: {
    playingSong: {
        songMid: string;
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
}) {
    const navigate = useNavigate();
    const {
        playingSong,
    } = props;
    const currentTime = useMemo(() => {
        return parseInt(playingSong.currentTime);
    }, [playingSong.currentTime]);

    const interval = useMemo(() => {
        return parseInt(playingSong.interval);
    }, [playingSong.interval]);

    const percent = useMemo(() => {
        return playingSong.currentTime / playingSong.interval * 100;
    }, [currentTime, interval]);

    const currentTimeFmt = useMemo(() => {
        return formatInterval(currentTime)
    }, [currentTime]);

    const intervalFmt = useMemo(() => {
        return formatInterval(interval)
    }, [interval]);

    return (
        <div className={styles.main}>
            <div className={styles.home}>
                <div className={styles.left}>
                    <img className={styles.logo} src={imgLogo} alt={'QQMusic'}/>
                    <NavBar/>
                </div>
                <div className={styles.right}>
                    <div className={styles.view}>
                        <Outlet/>
                    </div>
                </div>
            </div>
            <div className={styles.control}>
                <div className={styles.controlCover}>
                    <Image src={playingSong.albumCoverUrl || TestCoverImg} onClick={() => {
                        if (playingSong.songMid) {
                            navigate({
                                pathname: '/playing'
                            });
                        }
                    }}/>
                </div>
                <div className={styles.controlBtn}>
                    <span className="material-icons">play_circle</span>
                </div>
                <div className={styles.controlBtn}>
                    <span className="material-icons">pause_circle_filled</span>
                </div>
                <div className={styles.controlBtn}>
                    <span className="material-icons">favorite</span>
                </div>
                <div style={{height: '100%', width: '60vw', marginTop: '14vh'}}>
                    <div>
                        <ProgressBar percent={percent}/>
                    </div>
                    <div style={{display: 'flex', justifyContent: 'space-between'}}>
                        <span>{currentTimeFmt}</span>
                        <span>{intervalFmt}</span>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default connect(
    function (state: {
        playingSong: {
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
    }) {
        return {
            playingSong: state.playingSong
        };
    }
)(Home);