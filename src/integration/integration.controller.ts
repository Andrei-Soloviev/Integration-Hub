import { Body, Controller, Logger, Post } from '@nestjs/common';
import { CreateIntegrationDto } from './dto/create-integration.dto';
import { IntegrationService } from './integration.service';

@Controller('integrations')
export class IntegrationController {
  private _logger;
  constructor(private readonly integrationService: IntegrationService) {
    this._logger = new Logger(IntegrationController.name);
  }

  @Post()
  create(@Body() createIntegrationDto: CreateIntegrationDto) {
    this._logger.log(`createIntegrationDto: ${createIntegrationDto}`);
    this._logger.log(
      `createIntegrationDto json: ${JSON.stringify(createIntegrationDto)}`,
    );
    return this.integrationService.create(createIntegrationDto);
  }
}
