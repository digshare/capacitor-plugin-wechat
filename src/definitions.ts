export interface WechatPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  registerApp(): void;
  login(): void;
}
