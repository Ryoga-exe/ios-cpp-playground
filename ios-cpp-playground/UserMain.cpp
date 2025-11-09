//
//  UserMain.cpp
//  ios-cpp-playground
//
#include <cmath>
#include "GameAPI.hpp"

extern "C" void Main() {
  double t = 0.0;
  while (ryoga::WaitNextFrame()) {
    t += 1.0 / 60.0; // 仮の時間
    const float R = 0.5f + 0.5f*std::sin(t*0.7);
    const float G = 0.5f + 0.5f*std::sin(t*0.9 + 2.0);
    const float B = 0.5f + 0.5f*std::sin(t*1.3 + 4.0);
    ryoga::SetBackground(R, G, B);
  }
}
