import { getAllAlbums } from './albums';
import { Singer, SingerDetail } from '../model/singer';
import { Album } from '../model/album';
import { getAllSongs } from './songs';
import { Song } from '../model/song';

const singersMapCache: Map<string, {
  singer: SingerDetail;
  albums: Album[];
  topSongs: Song[];
}> = new Map();

const singersCache: Singer[] = [];

async function collectSingers() {
  const albums = await getAllAlbums();
  const songs = await getAllSongs();
  albums.forEach(album => {
    const singers = album.singers;
    singers.forEach(singer => {
      let detail = singersMapCache.get(singer.singerMid);
      if (!detail) {
        detail = {
          singer: {
            ...singer,
            description: '',
            avatarUrl: `https://y.gtimg.cn/music/photo_new/T001R800x800M000${singer.singerMid}_1.jpg`,
          },
          albums: [],
          topSongs: songs.filter((i) => i.singer.some(j => j.singerMid === singer.singerMid)),
        };
      }
      detail.albums.push(album);
      singersMapCache.set(singer.singerMid, detail);
    });
  });
}

export async function getAllSingers() {
  if (singersCache.length) {
    return singersCache;
  }
  await collectSingers();
  singersCache.push(...Array.from(singersMapCache.values()).map((i) => i.singer));
  return singersCache;
}

export async function getSingerAlbums(singerMid: string) {
  await collectSingers();
  return singersMapCache.get(singerMid)?.albums;
}

export async function getSingerTopSongs(singerMid: string) {
  await collectSingers();
  return singersMapCache.get(singerMid)?.topSongs;
}