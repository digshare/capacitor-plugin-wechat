import { WebPlugin } from '@capacitor/core';

import type { WechatPlugin } from './definitions';

export class WechatWeb extends WebPlugin implements WechatPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
