#ifndef LOSSY_COUNTER_H_
#define LOSSY_COUNTER_H_

#define KEY_TYPE unsigned long
#define VALUE_TYPE unsigned long

#include <sparsehash/sparse_hash_map>

typedef google::sparse_hash_map<KEY_TYPE, VALUE_TYPE> hash_t;

class LossyCounter {
 public:
  LossyCounter(float error);
  virtual ~LossyCounter();
  bool Init();
  void Increment(unsigned int key);
  hash_t::iterator Begin();
  hash_t::iterator End();

 private:
  float error_;
  unsigned int count_;
  unsigned int delta_;
  hash_t *hash_;
};

#endif // LOSSY_COUNTER_H_
