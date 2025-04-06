import * as path from 'node:path';
import * as fs from 'node:fs';
import { Song } from '../model/song';
import SongSource from '../model/source';

const songsCache: Song[] = [];
const songMap = new Map<
  string,
  {
    info: Song;
    audio: string;
    lyric: string;
    cover: string;
    dir: string;
  }
>();
const publicPath = path.join(__dirname, '../../', 'public');
const songDirs = fs
  .readdirSync(publicPath)
  .filter((file) => {
    return fs.statSync(`${publicPath}${path.sep}${file}`).isDirectory();
  })
  .filter((file) => {
    const files = fs.readdirSync(`${publicPath}${path.sep}${file}`);
    return (
      files.some((file) => path.extname(file) === '.mp3') &&
      files.some((file) => path.extname(file) === '.json')
    );
  });

export async function collectSongs(): Promise<Song[]> {
  if (songsCache.length > 0) {
    return songsCache;
  }
  const songs = await Promise.all(
    songDirs.map(async (file) => {
      const files = fs.readdirSync(`${publicPath}${path.sep}${file}`);
      const jsonPath = files.filter((f) => f.endsWith('.json'))[0];
      const coverPath = files.filter(
        (f) =>
          f.endsWith('.jpg') ||
          f.endsWith('.png') ||
          f.endsWith('.webp') ||
          f.endsWith('.bmp'),
      )[0];
      const lyricPath = files.filter((f) => f.endsWith('.lrc'))[0];
      const audioPath = files.filter(
        (f) => f.endsWith('.mp3') || f.endsWith('.m4a') || f.endsWith('.ogg'),
      )[0];
      const infoTextBuf = fs
        .readFileSync(`${publicPath}${path.sep}${file}${path.sep}${jsonPath}`)
        .toString('utf8');
      const json = JSON.parse(infoTextBuf);
      const info = Object.assign(
        {
          songId: json.songId,
          songMid: json.songMid,
          name: json.name,
          title: json.title,
          subtitle: json.subtitle,
          singer: (json.singer || []).map((s) => {
            return {
              singerId: s.id,
              singerMid: s.mid,
              name: s.name,
              dir: file,
            };
          }),
        },
        json.album
          ? {
              album: {
                albumId: json.album.albumId as number,
                albumMid: json.album.albumMid as string,
                name: json.album.name as string,
                cover: encodeURI(`/assets/${file}/${coverPath}`),
              },
            }
          : null,
      );
      songMap.set(info.songMid, {
        info,
        cover: coverPath,
        lyric: lyricPath,
        audio: audioPath,
        dir: file,
      });
      return info;
    }),
  );
  songsCache.push(...songs);
  return songs;
}

export async function getAllSongs(): Promise<Song[]> {
  return await collectSongs();
}

export async function findBySongId(songMid: string): Promise<Song | undefined> {
  if (songMap.size) {
    return songMap.get(songMid)?.info;
  }
  await collectSongs();
  return songMap.get(songMid)?.info;
}

export function getSongDirCover(dir: string): string {
  const subDir = `${publicPath}${path.sep}${dir}`;
  const file = fs.readdirSync(subDir).filter((f) =>
    f.endsWith('.jpg') ||
    f.endsWith('.png') ||
    f.endsWith('.webp') ||
    f.endsWith('.bmp'))[0];
  return encodeURI(`/assets/${dir}/${file}`);
}

export function getSongDirInfo(dir: string): Song {
  const subDir = `${publicPath}${path.sep}${dir}`;
  const file = fs.readdirSync(subDir).filter((f) =>
    f.endsWith('.json'))[0];
  const jsonPath = `${subDir}${path.sep}${file}`;
  const jsonText = fs.readFileSync(jsonPath).toString('utf8');
  return JSON.parse(jsonText);
}

export async function getSongSourceById(songMid: string): Promise<SongSource> {
  const song = await findBySongId(songMid);
  const detail = songMap.get(songMid);
  return {
    code: song ? 0 : -1,
    msg: song ? '' : '资源不存在或没有版权',
    url: encodeURI(`/assets/${detail?.dir}/${detail?.audio}`),
  };
}

export async function getSongLyricById(songMid: string): Promise<string> {
  await collectSongs();
  const detail = songMap.get(songMid);
  return fs.readFileSync(`${publicPath}${path.sep}${detail?.dir}${path.sep}${detail?.lyric}`).toString('utf8');
}
