import { Controller, Get } from '@nestjs/common';

@Controller('albums')
export class AlbumsController {
  @Get("/my/playlists")
  getMyPlaylists() {
    return Promise.resolve([]);
  }

  @Get("my/playlists/fav")
  getMyFavPlaylists() {
    return Promise.resolve([]);
  }

  @Get("/my/albums")
  getMyFavAlbums() {
    return Promise.resolve([]);
  }

  @Get("/my/albums/fav")
  getSingerAlbums() {
    return Promise.resolve([]);
  }

  @Get("/newest")
  getNewAlbums() {
    return Promise.resolve([]);
  }
}
