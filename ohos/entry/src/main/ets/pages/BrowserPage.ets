import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct BrowserPage {
  @State url: string = '';
  controller: webview.WebviewController = new webview.WebviewController();

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (params && params['url']) {
      this.url = params['url'] as string;
    }
  }

  build() {
    Column() {
      // 简单的导航栏
      Row() {
        // 返回按钮
        Text('< 返回') 
          .fontSize(16)
          .fontColor(Color.Blue)
          .margin({ left: 16 })
          .onClick(() => {
            if (this.controller.accessBackward()) {
              this.controller.backward();
            } else {
              router.back();
            }
          })
        Text('隐私政策')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .height(56)
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .margin({ top: 32 }) // 增加顶部 margin，避开系统状态栏

      // Web 组件
      Web({ src: this.url, controller: this.controller })
        .width('100%')
        .layoutWeight(1)
        .domStorageAccess(true)
        .javaScriptAccess(true)
    }
    .width('100%')
    .height('100%')
  }
}
