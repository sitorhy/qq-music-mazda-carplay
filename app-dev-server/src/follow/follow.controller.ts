import { Controller } from '@nestjs/common';

@Controller('follow')
export class FollowController {
  getFollowSingers(pageNo: number, pageSize: number) {
    return Promise.resolve([]);
  }
}
