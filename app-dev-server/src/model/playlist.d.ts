export interface Playlist {
  name: string; // 名称
  cover: string; // 专辑封面图片地址
  songCount: number; // 曲目数
  dissId: number; // Long类型，别名 tid，歌单公开id，只读用途, 0 = 无效不公开
  dirId: number; // Long类型，自建歌单id，收藏，删除收藏等修改操作用途
  nickname: string; // 作者
}