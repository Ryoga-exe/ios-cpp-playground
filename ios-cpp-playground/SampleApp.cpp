//
//  SampleApp.cpp
//  ios-cpp-playground
//

#include <cmath>
#include "SampleApp.hpp"

namespace { struct State { int w=0,h=0; float scale=1; double t=0; } S; }

extern "C" {
void SampleApp_Initialize(int w,int h,float scale){ S.w=w; S.h=h; S.scale=scale; S.t=0; }
void SampleApp_Resize(int w,int h,float scale){ S.w=w; S.h=h; S.scale=scale; }
void SampleApp_Frame(double dt,float* r,float* g,float* b){
  S.t += dt;
  float R=0.5f+0.5f*std::sin(S.t*0.7);
  float G=0.5f+0.5f*std::sin(S.t*0.9+2.0);
  float B=0.5f+0.5f*std::sin(S.t*1.3+4.0);
  if(r)*r=R; if(g)*g=G; if(b)*b=B;
}
void SampleApp_Shutdown(){}
}
