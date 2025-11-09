//
//  GameViewController.m
//  ios-cpp-playground
//

#import "GameViewController.h"
#import <MetalKit/MetalKit.h>

extern "C" void Main(); // ユーザ関数

#include <thread>
#include "FrameGate.hpp"
#include "SharedState.hpp"

@interface GameViewController () <MTKViewDelegate>
@end

@implementation GameViewController {
  MTKView *mtk;
  id<MTLCommandQueue> queue;
  BOOL started;
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
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!started) {
    started = YES;
    // ユーザの Main を別スレッドで起動（UIスレッドは描画更新を続ける）
    std::thread([]{ Main(); }).detach();
  }
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
  // 将来: Resize 通知を C++ 側へ渡すならここで
}

- (void)drawInMTKView:(MTKView *)view {
  // 共有ステートから背景色を読む
  auto& s = ryoga::ios::shared();
  view.clearColor = MTLClearColorMake(
    s.r.load(std::memory_order_relaxed),
    s.g.load(std::memory_order_relaxed),
    s.b.load(std::memory_order_relaxed), 1.0);

  // clear & present
  MTLRenderPassDescriptor *rp = view.currentRenderPassDescriptor;
  if (!rp || !view.currentDrawable) return;

  id<MTLCommandBuffer> cb = [queue commandBuffer];
  id<MTLRenderCommandEncoder> enc = [cb renderCommandEncoderWithDescriptor:rp];
  [enc endEncoding];
  [cb presentDrawable:view.currentDrawable];
  [cb commit];

  // 次フレームをユーザ側に通知
  ryoga::ios::gate().signal();
}
@end
