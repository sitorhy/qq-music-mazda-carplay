import { Controller, Get } from '@nestjs/common';

@Controller('category')
export class CategoryController {
  @Get("/recommended")
  getRecommendFeed() {

  }

  @Get("/hot")
  getHotCategory() {

  }

  @Get("/all")
  getAllTag() {

  }

  @Get("/playlist")
  getPlayListCategory() {

  }
}
