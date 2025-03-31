import { Singer } from './singer';
import { Album } from './album';

export interface Song {
  songId: number;
  songMid: string;
  name: string;
  title: string;
  subtitle: string;
  singer: Array<Singer>;
  album?: Album;
}
