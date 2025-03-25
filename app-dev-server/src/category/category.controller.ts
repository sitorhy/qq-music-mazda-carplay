import { Controller, Get } from '@nestjs/common';

@Controller('category')
export class CategoryController {
  @Get('/recommended')
  getRecommendFeed(pageNo: number, pageSize: number) {}

  @Get('/hot')
  getHotCategory() {}

  @Get('/all')
  getAllTag() {}

  @Get('/playlist')
  getPlayListCategory(categoryId: number, pageNo: number, pageSize: number) {}
}
