#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  //u_int32_t num_tag_bits = _cache_config.get_num_tag_bits();
  // Starting memory address of the Block

  // 32 bits
  // m = 32
  // need TAG
  // need BLOCK OFFSET
  // need INDEX

  uint32_t starting_tag = 0;
  uint32_t starting_block_offset = 0;
  uint32_t starting_index = 0;

  starting_tag = get_tag();
  starting_block_offset = _cache_config.get_num_block_offset_bits();
  starting_index = _cache_config.get_num_index_bits();

  uint32_t starting_address = 0;
  uint32_t temp = starting_tag << starting_index;
  temp = temp + _index;
  starting_address = temp << starting_block_offset;

  return starting_address;
}
