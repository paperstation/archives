#if defined(MAP_OVERRIDE_CONSTRUCTION)
#include "construction.dm"
#elif defined(MAP_OVERRIDE_DESTINY)
#include "destiny.dm"
#elif defined(MAP_OVERRIDE_TEST)
#include "testmap.dm"
#else
#include "standard.dm"
#endif