import { Injectable } from '@nestjs/common';

@Injectable()
export class IntegrationService {
  async create() {
    return 'Integration created';
  }
}
