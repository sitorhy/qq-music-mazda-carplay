import { Injectable } from '@nestjs/common';
import {
  getAllSongs,
  getSongLyricById,
  getSongSourceById,
} from '../data/songs';
import { getAlbumSongs } from '../data/albums';
import { getPlaylistSongsById } from '../data/playlists';
import { getSingerTopSongs } from '../data/singers';
import { PaginationResponse, Response } from '../model/response';
import { Song } from '../model/song';

@Injectable()
export class SongService {
  async getPlaylistSongs(dissId: number): Promise<Response<Song[]>> {
    const songs = await getPlaylistSongsById(dissId);
    return new Response<Song[]>({
      data: songs,
    });
  }

  async getSongSource(
    songMid: string,
    strMediaMid: string,
    type?: string,
  ): Promise<Response<string>> {
    return new Response({
      data: await getSongSourceById(songMid),
    });
  }

  async getAlbumSongs(
    albumMid: string,
    albumId: number,
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Song[]>> {
    const songs = await getAlbumSongs(albumMid);
    return new PaginationResponse<Song[]>({
      data: songs.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: songs.length,
    });
  }

  async getSingerTopSongs(
    singerMid: string,
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Song[]>> {
    const songs = await getSingerTopSongs(singerMid);
    return new PaginationResponse<Song[]>({
      data: songs.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: songs.length,
    });
  }

  async getNewSongs(): Promise<Response<Song[]>> {
    const songs = await getAllSongs();
    return new Response<Song[]>({
      data: songs.slice(0, 20),
    });
  }

  async getTopList(): Promise<Response<Song[]>> {
    const songs = await getAllSongs();
    return new Response<Song[]>({
      data: songs.slice(0, 20),
    });
  }

  async getSongLyric(songMid: string): Promise<Response<string>> {
    return new Response({
      data: await getSongLyricById(songMid),
    });
  }
}
