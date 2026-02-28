import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
<<<<<<< HEAD
    return 'Integration Hub is running';
=======
    return 'Hello World!';
>>>>>>> 49bfc567896079074ff003e1f37e7fe8aec9d189
  }
}
