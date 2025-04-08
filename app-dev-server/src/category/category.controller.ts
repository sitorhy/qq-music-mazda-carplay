import { Body, Controller, Get, Post } from '@nestjs/common';
import { CategoryService } from './category.service';

@Controller('category')
export class CategoryController {
  constructor(private readonly categoryService: CategoryService) {}

  @Post('/recommended')
  getRecommendFeed(@Body() params: { pageNo: number, pageSize: number; }) {
    return this.categoryService.getRecommendFeed(params.pageNo, params.pageSize);
  }

  @Get('/hot')
  getHotCategory() {
    return this.categoryService.getHotCategory();
  }

  @Get('/all')
  getAllTag() {
    return this.categoryService.getAllTag();
  }

  @Post('/playlist')
  getPlayListCategory(@Body() params: { categoryId: number, pageNo: number, pageSize: number; }) {
    return this.categoryService.getPlayListCategory(
      params.categoryId,
      params.pageNo,
      params.pageSize,
    );
  }
}
