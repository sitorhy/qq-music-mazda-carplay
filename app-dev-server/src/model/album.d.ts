import { Singer } from './singer';

export interface Album {
  albumId: number; // 专辑唯一标识
  albumMid: string; // 专辑唯一标识
  name: string; // 专辑名称
  cover: string; // 专辑封面图片地址
  songCount: number; // 曲目数，0无效值，最新接口没有该参数值
  singers: Array<Singer>;
  description: string;
}