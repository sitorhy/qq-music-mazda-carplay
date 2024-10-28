import {Outlet} from 'react-router-dom';
import NavBar from './NavBar.tsx';
import styles from '../style/Home.module.css';
import imgLogo from '../assets/qqmusic.png';
import {Image, ProgressBar} from "antd-mobile";
import TestCoverImg from "../assets/react.svg";

export default function Home() {
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
                    <Image src={TestCoverImg}/>
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
                    <ProgressBar percent={25}/>
                </div>
            </div>
        </div>
    );
}