import { Injectable } from '@nestjs/common';
import { CreateIntegrationDto } from './dto/create-integration.dto';

@Injectable()
export class IntegrationService {
  async create(createIntegrationDto: CreateIntegrationDto) {
    return 'Integration created';
  }
}
