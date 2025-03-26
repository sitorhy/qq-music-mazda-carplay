import { Injectable } from '@nestjs/common';

@Injectable()
export class CategoryService {
  getRecommendFeed(pageNo: number, pageSize: number) {}

  getHotCategory() {}

  getAllTag() {}

  getPlayListCategory(categoryId: number, pageNo: number, pageSize: number) {}
}
