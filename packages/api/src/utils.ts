import * as dotenv from 'dotenv';
import { resolve } from 'path';

dotenv.config({ path: resolve(__dirname, '../../.env') });

export function json(res: any, {status, message, data, exception}: { status: number; message: string, data?: any, exception?: any}) {
  if (status >= 400) {
    console.error(message, exception ?? 'No exception given');
  } else {
    console.log(message, exception ?? 'No exception given');
  }

  return res.status(status).json({
    message,
    data
  })
}