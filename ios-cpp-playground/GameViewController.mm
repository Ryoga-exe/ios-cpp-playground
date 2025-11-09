//
//  GameViewController.m
//  ios-cpp-playground
//

#import "GameViewController.h"
#import <MetalKit/MetalKit.h>

// C++ Sample
extern "C" {
  void SampleApp_Initialize(int w, int h, float scale);
  void SampleApp_Resize(int w, int h, float scale);
  void SampleApp_Frame(double dt, float* r, float* g, float* b);
  void SampleApp_Shutdown();
}

@interface GameViewController () <MTKViewDelegate>
@end

@implementation GameViewController {
  MTKView *mtk;
  id<MTLCommandQueue> queue;
  CFTimeInterval lastTS;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  id<MTLDevice> dev = MTLCreateSystemDefaultDevice();
  mtk = [[MTKView alloc] initWithFrame:self.view.bounds device:dev];
  mtk.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  mtk.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
  mtk.preferredFramesPerSecond = 60;
  mtk.paused = NO;
  mtk.enableSetNeedsDisplay = NO;
  mtk.delegate = self;
  [self.view addSubview:mtk];

  queue = [dev newCommandQueue];
  lastTS = CACurrentMediaTime();

  CGSize ds = mtk.drawableSize;
  SampleApp_Initialize((int)ds.width, (int)ds.height, (float)mtk.contentScaleFactor);
}

- (void)dealloc { SampleApp_Shutdown(); }

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
  SampleApp_Resize((int)size.width, (int)size.height, (float)view.contentScaleFactor);
}

- (void)drawInMTKView:(MTKView *)view {
  CFTimeInterval now = CACurrentMediaTime();
  double dt = now - lastTS; lastTS = now;

  float r=0.08f,g=0.08f,b=0.1f;
  SampleApp_Frame(dt, &r, &g, &b);
  view.clearColor = MTLClearColorMake(r, g, b, 1.0);

  MTLRenderPassDescriptor *rp = view.currentRenderPassDescriptor;
  if (!rp || !view.currentDrawable) return;

  id<MTLCommandBuffer> cb = [queue commandBuffer];
  id<MTLRenderCommandEncoder> enc = [cb renderCommandEncoderWithDescriptor:rp];
  [enc endEncoding];
  [cb presentDrawable:view.currentDrawable];
  [cb commit];
}
@end
