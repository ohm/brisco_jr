#include <math.h>
#include "lossy_counter.h"

LossyCounter::LossyCounter(float error) {
  count_ = 0;
  delta_ = 0;
  error_ = error;
  hash_ = NULL;
}

LossyCounter::~LossyCounter() {
  if (hash_ != NULL)
    delete(hash_);
}

bool LossyCounter::Init() {
  hash_ = new hash_t();
  if (hash_ == NULL)
    return false;

  hash_->set_deleted_key(NULL);
  return true;
}

void LossyCounter::Increment(unsigned int key) {
  /* increment the total number counted items */
  count_++;

  /* add key to the if not present, increment otherwise */
  hash_t::iterator it = hash_->find(key);
  if (it == hash_->end()) {
    hash_->insert(hash_t::value_type(key, 1 + delta_));
  } else {
    (*it).second++;
  }

  /* prune elements that didn't occur frequently enough */
  unsigned int new_delta = floor(count_ * error_);
  if (delta_ != new_delta) {
    for (it = hash_->begin(); it != hash_->end(); ++it) {
      if ((*it).second < new_delta) {
        hash_->erase(it);
      }
    }
    delta_ = new_delta;
  }
}

hash_t::iterator LossyCounter::Begin() {
  return hash_->begin();
}

hash_t::iterator LossyCounter::End() {
  return hash_->end();
}
