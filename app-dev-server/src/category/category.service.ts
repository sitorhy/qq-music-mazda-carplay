import { Injectable } from '@nestjs/common';
import { getAllPlaylists } from '../data/playlists';
import { getAllTagGroups, getTagsByGroupId } from '../data/tags';

@Injectable()
export class CategoryService {
  async getRecommendFeed(pageNo: number, pageSize: number) {
    return getTagsByGroupId(0x67);
  }

  async getHotCategory() {
    return getTagsByGroupId(0x68);
  }

  async getAllTag() {
    return getAllTagGroups();
  }

  async getPlayListCategory(categoryId: number, pageNo: number, pageSize: number) {
    return getAllPlaylists();
  }
}
