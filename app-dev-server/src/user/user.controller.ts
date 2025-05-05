import { Body, Controller, Get, Post } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/profile')
  getProfile() {
    return this.userService.getProfile();
  }

  @Get('/fav/songs')
  getFavSongs() {
    return this.userService.getFavSongs();
  }

  @Post('/fav/songs/add')
  addFavSong(@Body() params: { songMid: string }) {
    return this.userService.addFavSong(params.songMid);
  }

  @Post('/fav/songs/del')
  removeFavSong(@Body() params: { songMid: string }) {
    return this.userService.removeFavSong(params.songMid);
  }
}
