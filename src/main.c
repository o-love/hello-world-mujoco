#include <mujoco/mujoco.h>
#include "stdio.h"

char error[1000];
mjModel* m;
mjData* d;

int main(void) {
  // load model from file and check for errors
  m = mj_loadXML("hello.xml", NULL, error, 1000);
  if (!m) {
    printf("%s\n", error);
    return 1;
  }

  // make data corresponding to model
  d = mj_makeData(m);

  // run simulation for 10 seconds
  while (d->time < 10) {
    //printf("Time %d\n", d->time);
    printf("Time %.6f\n", d->time);
    mj_step(m, d);
  }

  // free model and data
  mj_deleteData(d);
  mj_deleteModel(m);

  return 0;
}
