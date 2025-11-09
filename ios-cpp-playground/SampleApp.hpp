//
//  SampleApp.hpp
//  ios-cpp-playground
//

#pragma once
extern "C" {
    void SampleApp_Initialize(int w, int h, float scale);
    void SampleApp_Resize(int w, int h, float scale);
    void SampleApp_Frame(double dt, float* r, float* g, float* b);
    void SampleApp_Shutdown();
}
