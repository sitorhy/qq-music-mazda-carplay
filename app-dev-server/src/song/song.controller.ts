import { Controller, Get } from '@nestjs/common';

@Controller('song')
export class SongController {
  @Get('/playlist')
  getPlaylistSongs(dissId: number) {
    return Promise.resolve([]);
  }

  @Get('/source')
  getSongSource(songMid: string, strMediaMid: string, type?: string) {
    return Promise.resolve([]);
  }

  @Get('/album')
  getAlbumSongs(
    albumMid: string,
    albumId: number,
    pageNo: number,
    pageSize: number,
  ) {
    return Promise.resolve([]);
  }

  @Get('/singer/top')
  getSingerTopSongs(singerMid: string, pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  @Get('/newest')
  getNewSongs() {
    return Promise.resolve([]);
  }

  @Get('/top')
  getTopList() {
    return Promise.resolve([]);
  }

  @Get('/lyric')
  getSongLyric(songMid: string) {
    return Promise.resolve([]);
  }
}
