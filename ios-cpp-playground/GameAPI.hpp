//
//  GameAPI.hpp
//  ios-cpp-playground
//
#pragma once
#include "FrameGate.hpp"
#include "SharedState.hpp"

namespace ryoga {
// 次フレームまでブロックして true を返す
inline bool WaitNextFrame() { ios::gate().wait(); return true; }

// 背景色を設定（0..1）
inline void SetBackground(float r, float g, float b) {
  auto& s = ios::shared();
  s.r.store(r, std::memory_order_relaxed);
  s.g.store(g, std::memory_order_relaxed);
  s.b.store(b, std::memory_order_relaxed);
}
} // namespace s3d
