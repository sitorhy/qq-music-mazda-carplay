import { Injectable } from '@nestjs/common';

@Injectable()
export class FollowService {
  getFollowSingers(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }
}
