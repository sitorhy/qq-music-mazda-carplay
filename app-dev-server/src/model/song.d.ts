import { Singer } from './singer';

export interface Song {
  songId: number;
  songMid: string;
  name: string;
  title: string;
  subtitle: string;
  singer: Array<Singer>;
  album?: {
    albumId: number;
    albumMid: string;
    name: string;
    cover: string;
  };
}
