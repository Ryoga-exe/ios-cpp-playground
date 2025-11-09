//
//  FrameGate.hpp
//  ios-cpp-playground
//

#pragma once
#include <mutex>
#include <condition_variable>

namespace ryoga::ios {
class FrameGate {
public:
  void signal() {
    std::lock_guard<std::mutex> lk(m_);
    signaled_ = true;
    cv_.notify_one();
  }
  void wait() {
    std::unique_lock<std::mutex> lk(m_);
    cv_.wait(lk, [this]{ return signaled_; });
    signaled_ = false;
  }
private:
  std::mutex m_;
  std::condition_variable cv_;
  bool signaled_ = false;
};

FrameGate& gate();      // グローバル取得
} // namespace ryoga::ios
