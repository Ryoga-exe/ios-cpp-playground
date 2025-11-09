//
//  SharedState.hpp
//  ios-cpp-playground
//
#pragma once
#include <atomic>
namespace ryoga::ios {
struct SharedState {
  std::atomic<float> r{0.08f}, g{0.08f}, b{0.10f};
};
SharedState& shared();
}
