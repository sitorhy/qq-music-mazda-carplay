import { Controller, Get } from '@nestjs/common';

@Controller('albums')
export class AlbumsController {
  @Get('/my/playlists')
  getMyPlaylists(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  @Get('my/playlists/fav')
  getMyFavPlaylists(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  @Get('/my/albums/fav')
  getMyFavAlbums(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  @Get('/singer/albums')
  getSingerAlbums(singerMid: string, pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  @Get('/newest')
  getNewAlbums(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }
}
