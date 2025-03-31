import fetch from 'node-fetch';
import fs from 'fs';
import path, { sep } from 'path';
import { fileURLToPath } from 'url'

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
                cover: `https://y.qq.com/music/photo_new/T002R300x300M000${json.req_1.data.track_info.album.mid}.jpg`,
            }
        }
        return song;
    });
}

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

function readDir(path, child = '') {
    const dirs = fs.readdirSync(path);
    dirs.forEach(dir => {
        const full = `${path}${sep}${dir}`;
        console.log(full);
        if (fs.existsSync(full) && fs.statSync(full).isDirectory) {
            const infoPath = `${full}${sep}info.json`;
            if (fs.existsSync(infoPath) && fs.statSync(infoPath).isFile) {
                const data = fs.readFileSync(infoPath, { encoding: "utf-8" });
                try {
                    const info = JSON.parse(data);
                    console.log(info);
                    fetchDetail(info.songMid).then(songDetail => {
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