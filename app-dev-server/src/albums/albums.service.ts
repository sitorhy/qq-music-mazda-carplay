import { Injectable } from '@nestjs/common';

@Injectable()
export class AlbumsService {
  getMyPlaylists(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  getMyFavPlaylists(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  getMyFavAlbums(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  getSingerAlbums(singerMid: string, pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }

  getNewAlbums(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }
}
