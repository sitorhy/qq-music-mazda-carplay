import { getAllSongs } from './songs';
import { Album } from '../model/album';
import { Song } from '../model/song';

const albumsCache: Map<
  string,
  {
    album: Album;
    songs: Song[];
  }
> = new Map();

async function collectAlbums() {
  if (albumsCache.size) {
    return albumsCache;
  }
  const songs = await getAllSongs();
  songs.forEach((song) => {
    if (song.album) {
      const album = {
        albumId: song.album.albumId,
        albumMid: song.album.albumMid,
        name: song.album.name,
        cover: song.album.cover,
        songCount: 0,
        singers: song.singer,
        description: song.album.name,
      };
      const albumDetail = albumsCache.get(album.albumMid as string);
      if (!albumDetail) {
        albumsCache.set(album.albumMid as string, {
          album,
          songs: [song],
        });
      } else {
        albumDetail.songs.push(song);
        albumDetail.album.songCount++;
      }
    }
  });

  return albumsCache;
}

export async function getAllAlbums(): Promise<Album[]> {
  await collectAlbums();
  return [...albumsCache.values()].map(i => i.album);
}


export async function getAlbumById(albumMid: string): Promise<Album | undefined> {
  await collectAlbums();
  return albumsCache.get(albumMid as string)?.album;
}

export async function getAlbumSongs(albumMid: string): Promise<Song[]> {
  await collectAlbums();
  const detail = albumsCache.get(albumMid as string);
  if (detail) {
    return detail.songs;
  }
  return [];
}