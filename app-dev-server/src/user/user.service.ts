import { Injectable } from '@nestjs/common';
import { Song } from '../model/song';
import { Response } from '../model/response';
import { getAllSongs } from '../data/songs';
import { assertHost } from '../data/config';

@Injectable()
export class UserService {
  private favSongs: Song[] = [];

  getProfile(): Promise<
    Response<{
      nick: string;
      headpic: string;
      uin: number;
      iconlist: {
        width: number;
        height: number;
        srcUrl: string;
      }[];
      backpic: {
        picurl: string;
      };
    }>
  > {
    return Promise.resolve(
      new Response({
        data: {
          nick: '测试用户',
          headpic: assertHost + encodeURI(`/assets/mc-icon-48b8d01f.png`),
          uin: 888888888,
          iconlist: [
            {
              width: 110,
              height: 46,
              srcUrl: assertHost + encodeURI(`/assets/profile/nvip6.png`),
            },
          ],
          backpic: {
            picurl:
              assertHost + encodeURI(`/assets/profile/T011M000001FIOvt4VuPOb.webp`),
          },
        },
        code: 200,
        message: '',
      }),
    );
  }

  getFavSongs(): Promise<Response<Song[]>> {
    return Promise.resolve(
      new Response({
        data: this.favSongs,
        code: 200,
        message: '',
      }),
    );
  }

  async addFavSong(songMid: string): Promise<Response<boolean>> {
    const index = this.favSongs.findIndex((i) => i.songMid === songMid);
    if (index < 0) {
      const songs = await getAllSongs();
      const item = songs.find((i) => i.songMid === songMid);
      if (item) {
        this.favSongs.unshift(item);
      } else {
        return Promise.resolve(
          new Response({
            data: false,
            code: 200,
            message: '',
          }),
        );
      }
    }
    return Promise.resolve(
      new Response({
        data: true,
        code: 200,
        message: '',
      }),
    );
  }

  removeFavSong(songMid: string): Promise<Response<boolean>> {
    const index = this.favSongs.findIndex((i) => i.songMid === songMid);
    if (index >= 0) {
      this.favSongs.splice(index, 1);
    }
    return Promise.resolve(
      new Response({
        data: index >= 0,
        code: 200,
        message: '',
      }),
    );
  }
}
