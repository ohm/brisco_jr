#include <erl_nif.h>
#include "lossy_counter.h"

static ERL_NIF_TERM increment(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]);
static ERL_NIF_TERM list(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]);
int on_load(ErlNifEnv *env, void **priv, ERL_NIF_TERM info);
void on_unload(ErlNifEnv *env, void *priv_data);

static ERL_NIF_TERM ATOM_OK = NULL;
static LossyCounter *counter = NULL;
static ErlNifMutex *counter_mutex = NULL;

/* Increment a given counter by one */
ERL_NIF_TERM increment(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  unsigned int key;
  if (!enif_get_uint(env, argv[0], &key))
    return enif_make_badarg(env);

  enif_mutex_lock(counter_mutex);
  counter->Increment(key);
  enif_mutex_unlock(counter_mutex);

  return ATOM_OK;
}

/* Retrieve a list of counter/value tuples */
ERL_NIF_TERM list(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  ERL_NIF_TERM list = enif_make_list(env, 0);

  enif_mutex_lock(counter_mutex);
  hash_t::iterator it = counter->Begin();
  while (it != counter->End()) {
    ERL_NIF_TERM key = enif_make_int(env, (*it).first);
    ERL_NIF_TERM val = enif_make_int(env, (*it).second);
    ERL_NIF_TERM head = enif_make_list2(env, key, val);
    list = enif_make_list_cell(env, head, list);
    it++;
  }
  enif_mutex_unlock(counter_mutex);

  return list;
}

int on_load(ErlNifEnv *env, void **priv, ERL_NIF_TERM info) {
  counter_mutex = enif_mutex_create((char *) "counter_mutex");
  if (counter_mutex == NULL)
    return 1;

  counter = new LossyCounter(0.01); /* TODO: Make error configurable */
  if (counter == NULL || !counter->Init())
    return 2;

  ATOM_OK = enif_make_atom(env, "ok");
  return 0;
}

void on_unload(ErlNifEnv *env, void *priv_data) {
  if (counter_mutex != NULL)
    enif_mutex_destroy(counter_mutex);

  if (counter != NULL)
    delete counter;
}

static ErlNifFunc nif_functions[] = {
  {"increment", 1, increment},
  {"list", 0, list}
};

extern "C" ERL_NIF_INIT(brisco_jr_counter,
                        nif_functions,
                        &on_load,
                        NULL,
                        NULL,
                        &on_unload);
