import { Injectable } from '@nestjs/common';
import { getAllSingers } from '../data/singers';

@Injectable()
export class FollowService {
  async getFollowSingers(pageNo: number, pageSize: number) {
    return getAllSingers();
  }
}
