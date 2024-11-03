import {connect} from "react-redux";
import {Ellipsis, Grid, Image, NavBar, ProgressBar} from "antd-mobile";

import '../style/PlayingScreen.css';
import {useNavigate} from "react-router-dom";
import {memo, useEffect, useMemo, useState} from "react";
import styles from "../style/Home.module.css";
import {formatInterval} from "../utils";

function LyricComponent (props: {
    lyricText: string
}) {
    const {
        lyricText
    } = props
    if (!lyricText) {
        return '';
    }
    const lines = lyricText.split('\n');
    const lyricInfo : {
        lines: {
            plainText: string;
            timeOfSeconds: number;
        } [];
        offset: number;
        by: string;
        al: string;
        ar: string;
        ti: string;
    } = {
        lines: [],
        offset: 0,
        by: '',
        al: '',
        ar: '',
        ti: ''
    };
    lines.forEach(line => {
        const matchs = /\[[\d:\.]+\]/.exec(line);
        if (matchs && matchs.length) {
            const plainText = line.slice(matchs[0].length);
            const timeSection = line.slice(0, matchs[0].length);
            const timeFmt = timeSection.slice(1, timeSection.length - 1);
            const timeUnits = timeFmt.split(':');

            const secUnit = timeUnits[timeUnits.length - 1];
            const minUnit = timeUnits[timeUnits.length - 2];
            const hourUnit = timeUnits[timeUnits.length - 3];
            const totalSecs = [secUnit, minUnit, hourUnit].filter(i => !!i).reduce((sum, unit, index) => {
               sum += parseFloat(unit) * Math.pow(60, index);
               return sum;
            }, 0);

            lyricInfo.lines.push({
                timeOfSeconds: totalSecs,
                plainText
            });
        } else {
            try {
                // 忽略非标准标签
                if (line.indexOf('ti:') > 0) {
                    lyricInfo.ti = line.slice('[ti:'.length, line.length - 1);
                } else if (line.indexOf('by:') > 0) {
                    lyricInfo.by = line.slice('[by:'.length, line.length - 1);
                } else if (line.indexOf('ar:') > 0) {
                    lyricInfo.ar = line.slice('[ar:'.length, line.length - 1);
                } else if (line.indexOf('al:') > 0) {
                    lyricInfo.al = line.slice('[al:'.length, line.length - 1);
                } else if (line.indexOf('offset:') > 0) {
                    const offset = line.slice('[offset:'.length, line.length - 1);
                    lyricInfo.offset = parseInt(offset);
                }
            } catch (e) {
                console.error(e);
            }
        }
    });
    console.log(lyricInfo)
    return lyricInfo.lines.map((line, index) => {
        return <p key={`${Date.now()}${index}`}>{line.plainText}</p>
    });
}

const LyricCacheComponent = memo(LyricComponent, function (prevProps, nextProps) {
    return prevProps.lyricText === nextProps.lyricText;
});

function PlayingScreen(props: {
    interval?: number;
    currentTime?: number;
    songUrl?: string;
    albumCoverUrl?: string;
    songName?: string;
    singers?: {
        name: string;
    }[];
    lyricText?: string;
}) {
    const navigate = useNavigate();
    const [songBackgroundStyle, setSongBackgroundStyle] = useState({});

    const {
        songName,
        albumCoverUrl,
        singers,
        lyricText
    } = props;

    useEffect(() => {
        setSongBackgroundStyle({
            backgroundImage: `url(${props.albumCoverUrl})`,
            backgroundRepeat: 'no-repeat',
            backgroundSize: 'cover',
            filter: 'blur(5vw)',
            position: 'absolute',
            top: 0,
            width: '100%',
            height: '100%',
            zIndex: 0,
        })
    }, [props.albumCoverUrl]);

    const currentTime = useMemo(() => {
        return parseInt(props.currentTime);
    }, [props.currentTime]);

    const interval = useMemo(() => {
        return parseInt(props.interval);
    }, [props.interval]);

    const percent = useMemo(() => {
        return props.currentTime / props.interval * 100;
    }, [currentTime, interval]);

    const currentTimeFmt = useMemo(() => {
        return formatInterval(currentTime)
    }, [currentTime]);

    const intervalFmt = useMemo(() => {
        return formatInterval(interval)
    }, [interval]);

    function onBack() {
        navigate(-1);
    }

    return (
        <div style={{width: '100%', height: '100%', position: 'relative'}}>
            <div className={'playing'}>
                <div>
                    <NavBar back='返回' onBack={onBack}>
                        {songName}
                    </NavBar>
                </div>
                <div className={'content'}>
                    <Grid columns={8}>
                        <Grid.Item span={3}>
                            <div className={'cover'}>
                                <Image style={{borderRadius: '50%'}} src={albumCoverUrl} width={150} height={150}
                                       fit='fill'/>
                            </div>
                        </Grid.Item>

                        <Grid.Item span={5}>
                            <div className={'detail'}>
                                <div className={'header'}>
                                    <Ellipsis content={
                                        Array.isArray(singers) ? singers.map(i => i.name).join('/ ') : ''
                                    }/>
                                </div>
                                <div className={'body'}>
                                    <LyricCacheComponent lyricText={lyricText || ''} />
                                </div>
                            </div>
                        </Grid.Item>
                    </Grid>
                </div>
                <div className={'control'} style={{paddingLeft: '8vw'}}>
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
            <div style={songBackgroundStyle}>
            </div>
            <div style={{
                backgroundColor: 'rgba(0, 0, 0, 0.46)',
                position: 'absolute',
                top: 0,
                width: '100%',
                height: '100%'
            }}></div>
        </div>
    );
}

export default connect(
    function (
        state: {
            playingSong: {
                interval?: number;
                currentTime?: number;
                songUrl?: string;
                albumCoverUrl?: string;
                songName?: string;
                singers?: {
                    name: string;
                }[];
                lyricText: string;
            }
        }
    ) {
        return state.playingSong;
    },
)(PlayingScreen);