import { Controller, Get } from '@nestjs/common';
import { SongService } from './song.service';

@Controller('song')
export class SongController {
  constructor(private readonly songService: SongService) {}

  @Get('/playlist')
  getPlaylistSongs(dissId: number) {
    return this.songService.getPlaylistSongs(dissId);
  }

  @Get('/source')
  getSongSource(songMid: string, strMediaMid: string, type?: string) {
    return this.songService.getSongSource(songMid, strMediaMid, type);
  }

  @Get('/album')
  getAlbumSongs(
    albumMid: string,
    albumId: number,
    pageNo: number,
    pageSize: number,
  ) {
    return this.songService.getAlbumSongs(albumMid, albumId, pageNo, pageSize);
  }

  @Get('/singer/top')
  getSingerTopSongs(singerMid: string, pageNo: number, pageSize: number) {
    return this.songService.getSingerTopSongs(singerMid, pageNo, pageSize);
  }

  @Get('/newest')
  getNewSongs() {
    return this.songService.getNewSongs();
  }

  @Get('/top')
  getTopList() {
    return this.songService.getTopList();
  }

  @Get('/lyric')
  getSongLyric(songMid: string) {
    return this.songService.getSongLyric(songMid);
  }
}
