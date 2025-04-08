import { Injectable } from '@nestjs/common';
import { getAllPlaylists } from '../data/playlists';
import { getAllTagGroups, getTagsByGroupId } from '../data/tags';
import { PaginationResponse, Response } from '../model/response';
import { Tag, TagGroup } from '../model/tag';
import { Playlist } from '../model/playlist';

@Injectable()
export class CategoryService {
  async getRecommendFeed(pageNo: number, pageSize: number): Promise<Response<Tag[]>> {
    const tags = await getTagsByGroupId(0x67);
    return new Response<Tag[]>({
      data: tags.slice(pageNo * (pageNo - 1), pageNo * pageSize),
    });
  }

  async getHotCategory(): Promise<Response<Tag[]>> {
    const tags = await getTagsByGroupId(0x68);
    return new Response<Tag[]>({
      data: tags,
    });
  }

  async getAllTag(): Promise<Response<TagGroup[]>> {
    const groups= await getAllTagGroups();
    return new Response<TagGroup[]>({
        data: groups,
    });
  }

  async getPlayListCategory(categoryId: number, pageNo: number, pageSize: number): Promise<PaginationResponse<Playlist[]>> {
    const testPlaylists = await getAllPlaylists();
    return new PaginationResponse<Playlist[]>({
      data: testPlaylists.slice(pageSize * (pageNo - 1), pageSize * pageNo),
      pageNo: pageNo,
      pageSize: pageSize,
      total: testPlaylists.length,
    });
  }
}
