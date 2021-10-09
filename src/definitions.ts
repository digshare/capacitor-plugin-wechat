export interface WechatPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
