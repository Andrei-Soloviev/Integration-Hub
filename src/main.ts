import { NestFactory } from '@nestjs/core';
<<<<<<< HEAD
import * as swaggerUi from 'swagger-ui-express';
import YAML from 'yamljs';
import { AppModule } from './app.module';

async function bootstrap() {
  const _app = await NestFactory.create(AppModule);

  // Создание документа Swagger
  const _swaggerDocument = YAML.load('docs/openapi.yaml');
  // Создание интерфейса Swagger
  _app.use('/docs', swaggerUi.serve, swaggerUi.setup(_swaggerDocument));

  // Запуск приложения
  await _app.listen(process.env.PORT ?? 3000);
=======
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(process.env.PORT ?? 3000);
>>>>>>> 49bfc567896079074ff003e1f37e7fe8aec9d189
}
bootstrap();
