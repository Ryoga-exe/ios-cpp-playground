//
//  SharedState.cpp
//  ios-cpp-playground
//

#include "SharedState.hpp"
namespace ryoga::ios {
static SharedState s;
SharedState& shared() { return s; }
} // namespace ryoga::ios
