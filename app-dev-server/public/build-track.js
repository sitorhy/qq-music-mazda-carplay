import fetch from 'node-fetch';
import fs from 'fs';
import path, { sep } from 'path';
import { fileURLToPath } from 'url'
import axios from 'axios';
import iconv from 'iconv-lite';
import { parseLyric, joinLyricData, toText } from './lyric-merge.js';

function parseHTML(str) {
    let replacements = {
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '""': "&quot;",
        "'": "&apos;",
        "<>": "&lt;&gt;",
    }
    for (const i in replacements) {
        str = str.replaceAll(replacements[i], i);
    }
    return str;
}

function getFileNameWithoutExtension(filePath) {
    return filePath.split('.').slice(0, -1).join('.');
}

function download(url, location) {
    axios({
        method: 'get',
        url: url,
        responseType: 'stream'
    })
        .then(response => {
            response.data.pipe(fs.createWriteStream(location));
        })
        .catch(error => {
            console.log(error);
        });
}

function downloadLyric(songMid, location) {
    axios({
        method: 'get',
        url: 'http://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg',
        headers: {
            Origin: 'https://y.qq.com',
            Referer: 'https://y.qq.com/'
        },
        params: {
            songmid: songMid,
            pcachetime: Date.now(),
            g_tk: 5381,
            loginUin: 0,
            hostUin: 0,
            inCharset: "utf8",
            outCharset: "utf-8",
            notice: 0,
            platform: "yqq",
            needNewCode: 0,
        }
    })
        .then(response => {
            const jsonText = response.data.slice("MusicJsonCallback(".length, response.data.length - 1);
            const json = JSON.parse(jsonText);
            if (!json.lyric) {
                console.warn(`${songMid} 没有歌词.`);
                return;
            }
            const lyricBufB64 = Buffer.from(json.lyric, 'base64');
            const lyricText = iconv.decode(lyricBufB64, 'utf8');
            if (json.trans) {
                const transBufB64 = Buffer.from(json.trans, 'base64');
                const transText = iconv.decode(transBufB64, 'utf8');
                
                const origLyricData = parseLyric(lyricText);
                const transLyricData = parseLyric(transText);

                const joinedData = joinLyricData(origLyricData.concat(transLyricData));
                const joinedText = toText(joinedData);
                fs.writeFileSync(location, parseHTML(joinedText));
            }
            else {
                fs.writeFileSync(location, parseHTML(lyricText));
            }
        })
        .catch(error => {
            console.log(error);
        });
}

function fetchDetail(song_mid) {
    return fetch("https://u6.y.qq.com/cgi-bin/musicu.fcg?_=1743440320945&sign=zzcd56d910nvfg92m66mhdcfgew52imbfou097ed0eb3", {
        "headers": {
            "accept": "application/json",
            "accept-language": "zh-CN,zh;q=0.9",
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded",
            "pragma": "no-cache",
            "priority": "u=1, i",
            "sec-ch-ua": "\"Chromium\";v=\"134\", \"Not:A-Brand\";v=\"24\", \"Google Chrome\";v=\"134\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Windows\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-site",
            "Referer": "https://y.qq.com/",
            "Referrer-Policy": "strict-origin-when-cross-origin"
        },
        "body": JSON.stringify(
            {
                "comm": {
                    "cv": 4747474,
                    "ct": 24,
                    "format": "json",
                    "inCharset": "utf-8",
                    "outCharset": "utf-8",
                    "notice": 0,
                    "platform": "yqq.json",
                    "needNewCode": 1,
                    "uin": 0,
                    "g_tk_new_20200303": 729215979,
                    "g_tk": 729215979
                },
                "req_1": {
                    "method": "get_song_detail_yqq",
                    "module": "music.pf_song_detail_svr",
                    "param": {
                        "song_mid": song_mid
                    }
                },
            }
        ),
        "method": "POST"
    }).then(res => res.json()).then(json => {
        const song = {
            songId: json.req_1.data.track_info.id,
            songMid: json.req_1.data.track_info.mid,
            name: json.req_1.data.track_info.name,
            title: json.req_1.data.track_info.title,
            subtitle: json.req_1.data.track_info.subtitle,
            singer: json.req_1.data.track_info.singer,
            album: {
                albumId: json.req_1.data.track_info.album.id,
                albumMid: json.req_1.data.track_info.album.mid,
                name: json.req_1.data.track_info.album.name,
                cover: `https://y.qq.com/music/photo_new/T002R800x800M000${json.req_1.data.track_info.album.mid}.jpg`,
            }
        }
        return song;
    });
}

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function readDir(path, child = '') {
    const dirs = fs.readdirSync(path);
    dirs.forEach(dir => {
        const full = `${path}${sep}${dir}`;
        if (fs.statSync(full).isDirectory()) {
            console.log(full);
            const infoPath = `${full}${sep}info.json`;
            const files = fs.readdirSync(full);
            const hasCover = files.some(i => i.lastIndexOf('.jpg') >= 0 || i.lastIndexOf('.png') >= 0 || i.lastIndexOf('.webp') >= 0);
            const hasLyric = files.some(i => i.lastIndexOf('.lrc') >= 0);
            const mp3Name = files.find(i => i.lastIndexOf('.mp3') >= 0 || i.lastIndexOf('.ogg') >= 0 || i.lastIndexOf('.m4a') >= 0);
            if (fs.existsSync(infoPath) && fs.statSync(infoPath).isFile) {
                const data = fs.readFileSync(infoPath, { encoding: "utf-8" });
                try {
                    const info = JSON.parse(data);
                    fetchDetail(info.songMid).then(songDetail => {
                        if (!hasCover) {
                            download(songDetail.album.cover, `${full}${sep}${songDetail.album.cover.split('/').slice(-1)}`);
                        }
                        if (!hasLyric) {
                            downloadLyric(songDetail.songMid, `${full}${sep}${getFileNameWithoutExtension(mp3Name)}.lrc`);
                        }
                        fs.writeFileSync(infoPath, JSON.stringify(songDetail, null, 2));
                    });
                } catch (e) {
                    console.error(e);
                }
            }
        }
    });
}

console.log(__dirname);
readDir(__dirname);