#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
   auto config = _cache->get_config();
   uint32_t index = extract_index(address, config);
   uint32_t tag = extract_tag(address, config);
   vector<Cache::Block*> blocks = _cache->get_blocks_in_set(index);
   for (uint32_t i = 0; i < blocks.size(); i++) {
     if (blocks[i]->is_valid() && blocks[i]->get_tag() == tag) {
        _hits++;
        return blocks[i];
     }
   }
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */

   auto config = _cache->get_config();
   uint32_t index = extract_index(address, config);
   uint32_t tag = extract_tag(address, config);
   vector<Cache::Block*> blocks = _cache->get_blocks_in_set(index);
   uint32_t least_used = blocks[0]->get_last_used_time();
   Cache::Block* least_used_block = blocks[0];
   for (uint32_t i = 0; i < blocks.size(); i++) {
     if ((!blocks[i]->is_valid())) {
        blocks[i]->set_tag(tag);
        blocks[i]->read_data_from_memory(_memory);
        blocks[i]->mark_as_valid();
        blocks[i]->mark_as_clean();
        return blocks[i];
     }
     if (blocks[i]->get_last_used_time() < least_used) {
          least_used = blocks[i]->get_last_used_time();
          least_used_block = blocks[i];
     }
   }

   if(least_used_block->is_dirty()) {
     least_used_block->write_data_to_memory(_memory);
   }
   least_used_block->set_tag(tag);
   least_used_block->read_data_from_memory(_memory);
   least_used_block->mark_as_valid();
   least_used_block->mark_as_clean();
   return least_used_block;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
   Cache::Block* curr_block = find_block(address);
   if (curr_block == NULL) {
     curr_block = bring_block_into_cache(address);
   }
   _use_clock++;
   curr_block->set_last_used_time(_use_clock.get_count());
   uint32_t block_offset = extract_block_offset(address, _cache->get_config());
   uint32_t read_data = curr_block->read_word_at_offset(block_offset);

  return read_data;
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
   // Step 1
   uint32_t copyAddress = address;
   uint32_t copyWord = word;
   Cache::Block * block_caching  = find_block(copyAddress);

   // Step 2
   if (block_caching == NULL) {
     // 2a
     if (_policy.is_write_allocate() == true) {
       block_caching = bring_block_into_cache(copyAddress);
     }
     // 2b
     if (_policy.is_write_allocate() == false) {
       _memory->write_word(copyAddress, copyWord);
       return;
     }
   }

   // Step 3
   _use_clock++;
   block_caching->set_last_used_time(_use_clock.get_count());

   // Step 4
   auto cache_config = _cache->get_config();
   uint32_t b_offset = extract_block_offset(copyAddress, cache_config);
   block_caching->write_word_at_offset(copyWord, b_offset);

   // Step 5
   if (_policy.is_write_back() == true) {
     block_caching->mark_as_dirty();
   }
   if (_policy.is_write_back() == false) {
     _memory->write_word(copyAddress, copyWord);
   }
}
