export interface Singer {
  singerId: number;
  singerMid: string;
  name: string;
}

export interface SingerDetail extends Singer {
  description: string;
  avatarUrl: string;
}
