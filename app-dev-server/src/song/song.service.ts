import { Injectable } from '@nestjs/common';

@Injectable()
export class SongService {
  getPlaylistSongs(dissId: number) {
    return Promise.resolve([]);
  }

  getSongSource(songMid: string, strMediaMid: string, type?: string) {
    return Promise.resolve([]);
  }

  getAlbumSongs(
    albumMid: string,
    albumId: number,
    pageNo: number,
    pageSize: number,
  ) {
    return Promise.resolve([]);
  }

  getSingerTopSongs(singerMid: string, pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  getNewSongs() {
    return Promise.resolve([]);
  }

  getTopList() {
    return Promise.resolve([]);
  }

  getSongLyric(songMid: string) {
    return Promise.resolve([]);
  }
}
