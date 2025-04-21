import { Body, Controller, Get, Post } from '@nestjs/common';
import { AlbumsService } from './albums.service';

@Controller('albums')
export class AlbumsController {
  constructor(private readonly albumsService: AlbumsService) {}

  @Post('/my/playlists')
  getMyPlaylists(@Body() params: { pageNo: number, pageSize: number; }) {
    return this.albumsService.getMyPlaylists(params.pageNo, params.pageSize);
  }

  @Post('my/playlists/fav')
  getMyFavPlaylists(@Body() params: { pageNo: number, pageSize: number; }) {
    return this.albumsService.getMyFavPlaylists(params.pageNo, params.pageSize);
  }

  @Post('/my/albums/fav')
  getMyFavAlbums(@Body() params: { pageNo: number, pageSize: number; }) {
    return this.albumsService.getMyFavAlbums(params.pageNo, params.pageSize);
  }

  @Post('/singer/albums')
  getSingerAlbums(@Body() params: { singerMid: string, pageNo: number, pageSize: number }) {
    return this.albumsService.getSingerAlbums(params.singerMid, params.pageNo, params.pageSize);
  }

  @Get('/newest/albums/tags')
  getNewAlbumTags() {
    return this.albumsService.getNewAlbumTags();
  }

  @Get('/newest/song/tags')
  getNewSongAlbumTags() {
    return this.albumsService.getNewSongAlbumTags();
  }

  @Get('/top/tags')
  getTopTags() {
    return this.albumsService.getTopTags();
  }
}
