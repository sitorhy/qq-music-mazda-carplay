import { Playlist } from '../model/playlist';
import { collectSongs, findBySongId, getSongDirCover, getSongDirInfo } from './songs';
import { Song } from '../model/song';

const playlistsCache: Playlist[] = [];
const playlistMap: Map<number, {
  playlist: Playlist;
  songs: Song[];
}> = new Map();

async function createPlaylists(): Promise<Playlist[]> {
  if (playlistsCache.length) {
    return playlistsCache;
  }
  await collectSongs();
  const playlist01: Playlist = {
    cover: getSongDirCover('陶喆 - 今天没回家'),
    dirId: 0x123,
    dissId: 0x123456,
    name: '华语歌单',
    nickname: 'User',
    songCount: 0,
  };

  playlistsCache.push(playlist01 as Playlist);
  playlistMap.set(playlist01.dissId, {
    playlist: playlist01,
    songs: []
  });
  Promise.all(
    [
      '伍佰 & China Blue - 再度重相逢',
      '告五人 - 带我去找夜生活',
      '告五人 - 爱人错过',
      '周华健 - 花心',
      '张芸京 - 偏爱',
      '李荣浩 - 李白',
      '萧亚轩 - 遗失的心跳',
      '蔡健雅 - Letting Go',
      '陶喆 - 今天没回家'
    ].map((dir) => {
      const info = getSongDirInfo(dir) as Song;
      return findBySongId(info.songMid as string).then(song => {
        return song as Song;
      });
    })
  ).then(songs => {
    const playlist = playlistMap.get(playlist01.dissId);
    if (playlist) {
      playlist.playlist.songCount = songs.length;
      playlist.songs = songs;
    }
  });


  const playlist02: Playlist = {
    cover: getSongDirCover('Aimer EGOIST - ninelie'),
    dirId: 0x124,
    dissId: 0x123457,
    name: '日语歌单',
    nickname: 'User',
    songCount: 0,
  };

  playlistsCache.push(playlist02 as Playlist);
  playlistMap.set(playlist02.dissId, {
    playlist: playlist02,
    songs: []
  });
  Promise.all(
    [
      '鬼頭明里 - キミのとなりで',
      '鈴木みのり - 夜空',
      '千菅春香 - 愛の詩',
      'スキマスイッチ - アイスクリーム シンドローム',
      'やなぎなぎ - ビードロ模様',
      'You\'re the Shine',
      'Tamame - Ebb and Flow',
      'Ray - a-gain',
      'Elements Garden - 彼女達のコントレイル',
      'AZKi - いのち',
      'Aimer EGOIST - ninelie',
      'A Page of My Story'
    ].map((dir) => {
      const info = getSongDirInfo(dir) as Song;
      return findBySongId(info.songMid as string).then(song => {
        return song as Song;
      });
    })
  ).then(songs => {
    const playlist = playlistMap.get(playlist02.dissId);
    if (playlist) {
      playlist.playlist.songCount = songs.length;
      playlist.songs = songs;
    }
  });

  const playlist03: Playlist = {
    cover: getSongDirCover('Falcom Sound Team J.D.K. - アインヘル小要塞'),
    dirId: 0x125,
    dissId: 0x123458,
    name: '纯音乐',
    nickname: 'User',
    songCount: 0,
  };

  playlistsCache.push(playlist03 as Playlist);
  playlistMap.set(playlist03.dissId, {
    playlist: playlist03,
    songs: []
  });
  Promise.all(
    [
      'A Beautiful Farewell',
      'Falcom Sound Team J.D.K. - Lift-off!',
      'Falcom Sound Team J.D.K. - Lyrical Amber',
      'Falcom Sound Team J.D.K. - アインヘル小要塞',
      'Falcom Sound Team J.D.K. - スタートライン',
      'Blue Destination',
      'Life Of Sin Pt. 3',
      '太空漫步 Space Walk',
      '失眠症 Dance in a Deep Dream',
      '宮崎誠 - 正義執行 第二撃',
      '景山将太 - ミナモシティ',
      '景星庆云',
      '梶浦由記 - battle of the shadows',
      '神前暁 - Vivy -Unrivaled-',
    ].map((dir) => {
      const info = getSongDirInfo(dir) as Song;
      return findBySongId(info.songMid as string).then(song => {
        return song as Song;
      });
    })
  ).then(songs => {
    const playlist = playlistMap.get(playlist03.dissId);
    if (playlist) {
      playlist.playlist.songCount = songs.length;
      playlist.songs = songs;
    }
  });

  const playlist04: Playlist = {
    cover: getSongDirCover('希望有羽毛和翅膀'),
    dirId: 0x126,
    dissId: 0x123459,
    name: '我的收藏',
    nickname: 'User',
    songCount: 0,
  };

  playlistsCache.push(playlist04 as Playlist);
  playlistMap.set(playlist04.dissId, {
    playlist: playlist04,
    songs: []
  });
  Promise.all(
    [
      'Different Lives',
      'LiGHTs - プラネタリウム',
      'Philter - Adventure Time',
      'RAISE A SUILEN - Sacred world',
      'Ramin Djawadi - Driving With The Top Down',
      'SAYA - Frozen Hope',
      'Simons - Lambada',
      '川田まみ - 緋色の空',
      '希望有羽毛和翅膀',
    ].map((dir) => {
      const info = getSongDirInfo(dir) as Song;
      return findBySongId(info.songMid as string).then(song => {
        return song as Song;
      });
    })
  ).then(songs => {
    const playlist = playlistMap.get(playlist04.dissId);
    if (playlist) {
      playlist.playlist.songCount = songs.length;
      playlist.songs = songs;
    }
  });

  return playlistsCache;
}


export async function getAllPlaylists() {
  await createPlaylists();
  return playlistsCache;
}

export async function getPlaylistSongsById(dissId: number) {
  await createPlaylists();
  return playlistMap.get(dissId)?.songs || [];
}