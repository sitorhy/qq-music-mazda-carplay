import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AlbumsModule } from './albums/albums.module';
import { CategoryModule } from './category/category.module';
import { UserModule } from './user/user.module';
import { SongModule } from './song/song.module';
import { FollowModule } from './follow/follow.module';

@Module({
  controllers: [AppController],
  providers: [AppService],
  imports: [AlbumsModule, CategoryModule, UserModule, SongModule, FollowModule],
})
export class AppModule {}
