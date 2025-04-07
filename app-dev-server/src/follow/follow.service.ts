import { Injectable } from '@nestjs/common';
import { Singer } from '../model/singer';
import { PaginationResponse } from '../model/response';
import { getAllSingers } from '../data/singers';

@Injectable()
export class FollowService {
  async getFollowSingers(
    pageNo: number,
    pageSize: number,
  ): Promise<PaginationResponse<Singer[]>> {
    const singers: Singer[] = await getAllSingers();
    return new PaginationResponse<Singer[]>({
      data: singers.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: singers.length,
    });
  }
}
