import { Controller, Get } from '@nestjs/common';
import { AlbumsService } from './albums.service';

@Controller('albums')
export class AlbumsController {
  constructor(private readonly albumsService: AlbumsService) {}

  @Get('/my/playlists')
  getMyPlaylists(pageNo: number, pageSize: number) {
    return this.albumsService.getMyPlaylists(pageNo, pageSize);
  }

  @Get('my/playlists/fav')
  getMyFavPlaylists(pageNo: number, pageSize: number) {
    return this.albumsService.getMyFavPlaylists(pageNo, pageSize);
  }

  @Get('/my/albums/fav')
  getMyFavAlbums(pageNo: number, pageSize: number) {
    return this.albumsService.getMyFavAlbums(pageNo, pageSize);
  }

  @Get('/singer/albums')
  getSingerAlbums(singerMid: string, pageNo: number, pageSize: number) {
    return this.albumsService.getSingerAlbums(singerMid, pageNo, pageSize);
  }

  @Get('/newest')
  getNewAlbums(pageNo: number, pageSize: number) {
    return this.albumsService.getNewAlbums(pageNo, pageSize);
  }
}
