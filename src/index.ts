import { registerPlugin } from '@capacitor/core';

import type { WechatPlugin } from './definitions';

const Wechat = registerPlugin<WechatPlugin>('Wechat', {
  web: () => import('./web').then(m => new m.WechatWeb()),
});

export * from './definitions';
export { Wechat };
