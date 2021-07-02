#include "simplecache.h"
int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  auto cache_block = _cache.find(index);
  for (u_int32_t i = 0; i < cache_block->second.size(); i++) {
    if (cache_block->second[i].valid() && cache_block->second[i].tag() == tag) {
      return cache_block->second[i].get_byte(block_offset);
    }
    //std::cout << test->second[i].tag() << '\n';
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in C++ (hint: Rule of Three)
  auto cache_block = _cache.find(index);
  size_t _size = cache_block->second.size();
  for (u_int32_t i = 0; i < _size; i++) {
    if (!cache_block->second[i].valid()) {
      cache_block->second[i].replace(tag, data);
      return;
    } else if(cache_block->second[i].valid() && (i == _size - 1)) {
      cache_block->second[0].replace(tag, data);
      return;
    }
  }
}
