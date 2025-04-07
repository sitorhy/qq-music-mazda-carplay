import { Injectable } from '@nestjs/common';
import { getAllPlaylists } from '../data/playlists';
import { getAllAlbums } from '../data/albums';
import { getSingerAlbums } from '../data/singers';
import { PaginationResponse } from '../model/response';
import { Playlist } from '../model/playlist';
import { Album } from '../model/album';

@Injectable()
export class AlbumsService {
  async getMyPlaylists(
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Playlist[]>> {
    const testPlaylists = await getAllPlaylists();
    return new PaginationResponse<Playlist[]>({
      data: testPlaylists.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: testPlaylists.length,
    });
  }

  async getMyFavPlaylists(
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Playlist[]>> {
    const testPlaylists = await getAllPlaylists();
    return new PaginationResponse<Playlist[]>({
      data: testPlaylists.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: testPlaylists.length,
    });
  }

  async getMyFavAlbums(
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Album[]>> {
    const testAlbums = await getAllAlbums();
    return new PaginationResponse<Album[]>({
      data: testAlbums.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: testAlbums.length,
    });
  }

  async getSingerAlbums(
    singerMid: string,
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Album[]>> {
    const singerAlbums = await getSingerAlbums(singerMid);
    return new PaginationResponse<Album[]>({
      data: singerAlbums.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: singerAlbums.length,
    });
  }

  async getNewAlbums(
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Album[]>> {
    const testAlbums = await getAllAlbums();
    return new PaginationResponse<Album[]>({
      data: testAlbums.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: testAlbums.length,
    });
  }
}
