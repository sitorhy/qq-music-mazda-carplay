/// <reference types="vite/client" />

declare interface Album {
    title: string;
    subtitle: string;
    picUrl: string;
    author: string;
    dirId: number; // 私有的自建歌单id
    albumMid: string; // 公开的发行版专辑id
    dissId: string; // 公开的非发行版歌单id
}

declare interface Song {
    dissId: string;
    dissName: string;
    albumMid: string;
    albumName: string;
    albumCoverUrl: string;
    songMid: string;
    songName: string;
    songOrig: string;
    strMediaMid: string;
    interval: number;
    singers?: {
       name: string;
    }[]
}

declare interface SongSource {
    type: string;
    expire: number;
    url: string;
}

declare interface Category {
    categoryType: string;
    categoryCode: string;
    categoryName?: string;
    groupId?: string;
    groupName?: string;
    albums?: Partial<Album>[];
    songs?: Partial<Song>[];
    total: number;
    pageNo: number;
    pageSize: number;
    loading?: boolean;
}

declare interface Meta {
    title: string;
    categories: Category[];
    categoryTypes: string[];
}

declare type MetaList = Meta[];

declare interface CategoryPopupGroup {
    groupName: string;
    groupId: string;
    categories: Category[];
}