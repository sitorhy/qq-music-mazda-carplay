import { Controller, Get } from '@nestjs/common';
import { AlbumsService } from '../albums/albums.service';
import { FollowService } from './follow.service';

@Controller('follow')
export class FollowController {
  constructor(private readonly followService: FollowService) {}

  @Get("/singers")
  getFollowSingers(pageNo: number, pageSize: number) {
    return this.followService.getFollowSingers(pageNo, pageSize);
  }
}
