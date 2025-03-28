import { Song } from './song';

export interface TopGroup {
  topGroupId: number;
  topGroupName: string;
}

export interface Top {
  topId: number;
  topName: string;
  title: string;
  titleDetail: string;
  titleShare: string;
  period: string;
  updateTime: string;
  song: Array<Song>;
}