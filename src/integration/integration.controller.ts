import { Controller, Post } from '@nestjs/common';

@Controller('integrations')
export class IntegrationController {
  @Post()
  create() {
    return 'Created';
  }
}
