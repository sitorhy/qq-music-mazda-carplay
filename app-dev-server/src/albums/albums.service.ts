import { Injectable } from '@nestjs/common';
import { getAllPlaylists } from '../data/playlists';
import { getAllAlbums } from '../data/albums';
import { getSingerAlbums } from '../data/singers';

@Injectable()
export class AlbumsService {
  async getMyPlaylists(pageNo: number, pageSize: number) {
    return getAllPlaylists();
  }

  async getMyFavPlaylists(pageNo: number, pageSize: number) {
    return getAllPlaylists();
  }

  async getMyFavAlbums(pageNo: number, pageSize: number) {
    return getAllAlbums();
  }

  async getSingerAlbums(singerMid: string, pageNo: number, pageSize: number) {
    return getSingerAlbums(singerMid);
  }

  async getNewAlbums(pageNo: number, pageSize: number) {
    return getAllAlbums();
  }
}
