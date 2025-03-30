import { Controller, Get } from '@nestjs/common';
import { AlbumsService } from '../albums/albums.service';
import { CategoryService } from './category.service';

@Controller('category')
export class CategoryController {
  constructor(private readonly categoryService: CategoryService) {}

  @Get('/recommended')
  getRecommendFeed(pageNo: number, pageSize: number) {
    return this.categoryService.getRecommendFeed(pageNo, pageSize);
  }

  @Get('/hot')
  getHotCategory() {
    return this.categoryService.getHotCategory();
  }

  @Get('/all')
  getAllTag() {
    return this.categoryService.getAllTag();
  }

  @Get('/playlist')
  getPlayListCategory(categoryId: number, pageNo: number, pageSize: number) {
    return this.categoryService.getPlayListCategory(
      categoryId,
      pageNo,
      pageSize,
    );
  }
}
