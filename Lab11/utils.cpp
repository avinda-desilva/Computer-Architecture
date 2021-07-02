#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t num_tag_bits = cache_config.get_num_tag_bits();
  uint32_t num_index_bits = cache_config.get_num_index_bits();
  uint32_t num_block_offset_bits = cache_config.get_num_block_offset_bits();
  if (num_tag_bits <= 31) {
    return (address & ((1 << num_tag_bits) - 1) << (num_index_bits + num_block_offset_bits)) >> (num_index_bits + num_block_offset_bits);
  }
  return address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t num_index_bits = cache_config.get_num_index_bits();
  uint32_t num_block_offset_bits = cache_config.get_num_block_offset_bits();
  if (num_index_bits <= 31) {
    return (address & ((1 << num_index_bits) - 1) << (num_block_offset_bits)) >> (num_block_offset_bits);
  }
  return address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t num_block_offset_bits = cache_config.get_num_block_offset_bits();
  if (num_block_offset_bits <= 31) {
    return (address & ((1 << num_block_offset_bits) - 1));
  }
  return address;
}
