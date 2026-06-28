import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { IntegrationModule } from './integration/integration.module';

@Module({
  imports: [ConfigModule.forRoot(), IntegrationModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
