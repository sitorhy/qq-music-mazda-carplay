import { Injectable } from '@nestjs/common';
import SongSource from '../model/source';
import { getAllSongs, getSongLyricById, getSongSourceById } from '../data/songs';
import { getAlbumSongs } from '../data/albums';
import { getPlaylistSongsById } from '../data/playlists';
import { getSingerTopSongs } from '../data/singers';

@Injectable()
export class SongService {
  getPlaylistSongs(dissId: number) {
    return getPlaylistSongsById(dissId);
  }

  async getSongSource(
    songMid: string,
    strMediaMid: string,
    type?: string,
  ): Promise<SongSource> {
    return getSongSourceById(songMid);
  }

  async getAlbumSongs(
    albumMid: string,
    albumId: number,
    pageNo: number,
    pageSize: number,
  ) {
    return await getAlbumSongs(albumMid);
  }

  async getSingerTopSongs(singerMid: string, pageNo: number, pageSize: number) {
    return getSingerTopSongs(singerMid);
  }

  async getNewSongs() {
    const songs = await getAllSongs();
    return songs.slice(0, 20);
  }

  async getTopList() {
    const songs = await getAllSongs();
    return songs.slice(10, 30);
  }

  async getSongLyric(songMid: string) {
    return await getSongLyricById(songMid);
  }
}
