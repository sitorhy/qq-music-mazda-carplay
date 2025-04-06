import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { SongService } from './song.service';

@Controller('song')
export class SongController {
  constructor(private readonly songService: SongService) {}

  @Get('/playlist')
  getPlaylistSongs(dissId: number) {
    return this.songService.getPlaylistSongs(dissId);
  }

  @Post('/source')
  getSongSource(
    @Body() params: { songMid: string; strMediaMid: string; type?: string },
  ) {
    return this.songService.getSongSource(
      params.songMid,
      params.strMediaMid,
      params.type,
    );
  }

  @Post('/album')
  getAlbumSongs(
    @Body()
    params: {
      albumMid: string;
      albumId: number;
      pageNo: number;
      pageSize: number;
    },
  ) {
    return this.songService.getAlbumSongs(
      params.albumMid,
      params.albumId,
      params.pageNo,
      params.pageSize,
    );
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

  @Post('/lyric')
  getSongLyric(@Body() params: { songMid: string }) {
    return this.songService.getSongLyric(params.songMid);
  }
}
