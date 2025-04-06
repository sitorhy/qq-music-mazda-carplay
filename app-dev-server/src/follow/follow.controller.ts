import { Body, Controller, Get, Post } from '@nestjs/common';
import { FollowService } from './follow.service';

@Controller('follow')
export class FollowController {
  constructor(private readonly followService: FollowService) {}

  @Post('/singers')
  getFollowSingers(@Body() params: { pageNo: number, pageSize: number; }) {
    return this.followService.getFollowSingers(params?.pageNo, params?.pageSize);
  }
}
