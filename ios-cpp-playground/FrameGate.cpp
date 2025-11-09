//
//  FrameGate.cpp
//  ios-cpp-playground
//
#include "FrameGate.hpp"
namespace ryoga::ios {
static FrameGate g;
FrameGate& gate() { return g; }
} // namespace ryoga::ios
