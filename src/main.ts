import SwaggerParser from '@apidevtools/swagger-parser';
import { NestFactory } from '@nestjs/core';
import * as path from 'path';
import * as swaggerUi from 'swagger-ui-express';
import { AppModule } from './app.module';

async function bootstrap() {
  const _app = await NestFactory.create(AppModule);

  try {
    // 1. Указываем путь к главному файлу OpenAPI
    const openApiPath = path.resolve(process.cwd(), 'docs/openapi.yaml');
    // 2. Собираем все файлы в один объект, разрешая все $ref ссылки
    const swaggerDocument = await SwaggerParser.bundle(openApiPath);

    // 3. Создание и настройка интерфейса Swagger UI
    _app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
  } catch (error) {
    console.error('Failed to generate Swagger documentation', error);
  }

  const port = process.env.PORT || 3000;
  await _app.listen(port);
  console.log(`Application is running on: http://localhost:${port}`);
}
bootstrap();
