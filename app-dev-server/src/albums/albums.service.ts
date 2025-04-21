import { Injectable } from '@nestjs/common';
import { getAllPlaylists } from '../data/playlists';
import { getAllAlbums } from '../data/albums';
import { getSingerAlbums } from '../data/singers';
import { PaginationResponse, Response } from '../model/response';
import { Playlist } from '../model/playlist';
import { Album } from '../model/album';
import { Tag } from '../model/tag';

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

  async getNewAlbumTags() {
    return new Response<Tag[]>({
      data: [
        {
          tagId: 0x501,
          tagName: '内地',
        },
        {
          tagId: 0x502,
          tagName: '港台',
        },
        {
          tagId: 0x503,
          tagName: '欧美',
        },
        {
          tagId: 0x504,
          tagName: '韩国',
        },
        {
          tagId: 0x505,
          tagName: '日本',
        },
      ],
    });
  }

  async getNewSongAlbumTags() {
    return new Response<Tag[]>({
      data: [
        {
          tagId: 0x600,
          tagName: '最新',
        },
        {
          tagId: 0x601,
          tagName: '内地',
        },
        {
          tagId: 0x602,
          tagName: '港台',
        },
        {
          tagId: 0x603,
          tagName: '欧美',
        },
        {
          tagId: 0x604,
          tagName: '韩国',
        },
        {
          tagId: 0x605,
          tagName: '日本',
        },
      ],
    });
  }

  getTopTags() {
    return new Response<Tag[]>({
      data: [
        {
          tagId: 0x700,
          tagName: '热歌',
        },
        {
          tagId: 0x701,
          tagName: '新歌',
        },
        {
          tagId: 0x702,
          tagName: '流行指数',
        },
        {
          tagId: 0x703,
          tagName: '欧美',
        },
        {
          tagId: 0x704,
          tagName: '韩国',
        },
      ],
    });
  }
}
