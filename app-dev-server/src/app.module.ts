import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ServeStaticModule } from '@nestjs/serve-static';
import { AlbumsModule } from './albums/albums.module';
import { CategoryModule } from './category/category.module';
import { UserModule } from './user/user.module';
import { SongModule } from './song/song.module';
import { FollowModule } from './follow/follow.module';
import { join } from 'path';

@Module({
  controllers: [AppController],
  providers: [AppService],
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
      serveRoot: '/assets',
    }),
    AlbumsModule,
    CategoryModule,
    UserModule,
    SongModule,
    FollowModule,
  ],
})
export class AppModule {}
