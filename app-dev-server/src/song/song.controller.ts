import { Controller, Get } from '@nestjs/common';

@Controller('song')
export class SongController {
  @Get("/playlist")
  getPlaylistSongs(){
    return Promise.resolve([]);
  }

  @Get("/source")
  getSongSource(){
    return Promise.resolve([]);
  }

  @Get("/album")
  getAlbumSongs(){
    return Promise.resolve([]);
  }

  @Get("/singer/top")
  getSingerTopSongs(){
    return Promise.resolve([]);
  }

  @Get("/newest")
  getNewSongs(){
    return Promise.resolve([]);
  }

  @Get("/top")
  getTopList(){
    return Promise.resolve([]);
  }

  @Get("/lyric")
  getSongLyric(){
    return Promise.resolve([]);
  }
}
