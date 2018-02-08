/*
cmex5 -I/u/tpminka/matlab train_mean_counts_c.c ~/matlab/util.o -lm
*/
#include "mex.h"
#include <math.h>
#include "util.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  const mxArray *obj, *pa;
  double *a, *old_a, *data, *weight;
  int K,N;
  int i,k;
  int iter, iters;
  double s;
  int sparse = 0, *rowOf, *firstInCol;

  if((nrhs < 2) || (nrhs > 3)) {
    mexErrMsgTxt("Usage: a = train_mean_counts_c(obj, data, weight)");
  }
  /* obj.a is a row or col vector 
   * data is a matrix of rows
   */
  obj = prhs[0];
  pa = mxGetField(obj, 0, "a");
  if(mxGetM(pa) == 1) K = mxGetN(pa);
  else if(mxGetN(pa) == 1) K = mxGetM(pa);
  else mexErrMsgTxt("a is the wrong size");
  
  a = mxGetPr(plhs[0] = mxCreateDoubleMatrix(mxGetM(pa), mxGetN(pa), mxREAL));
  memcpy(a, mxGetPr(pa), K*sizeof(double));

  pa = prhs[1];
  N = mxGetM(pa);
  if(mxGetN(pa) != K)
    mexErrMsgTxt("data is the wrong size");
  data = mxGetPr(pa);
  if(mxIsSparse(pa)) {
    sparse = 1;
    rowOf = mxGetIr(pa);
    firstInCol = mxGetJc(pa);
  }

#if 0
  if(nrhs > 2) {
    iters = *mxGetPr(prhs[2]);
  }
  else iters = 20;
#else
  if(nrhs > 2) {
    if(mxGetM(prhs[2]) != N || mxGetN(prhs[2]) != 1)
      mexErrMsgTxt("weight is the wrong size");
    weight = mxGetPr(prhs[2]);
  }
  else weight = NULL;
#endif

  old_a = mxCalloc(K, sizeof(double));

  s = 0;
  for(k=0;k<K;k++) s += a[k];

  for(iter=0;iter<20;iter++) {
    double f, maxdiff;
    memcpy(old_a, a, K*sizeof(double));

    /* loop words */
    f = 0;
    for(k=0;k<K;k++) {
      double m = 1e-10;
      if(!sparse) {
	for(i=0;i<N;i++) {
	  double w = 1;
	  int count = data[i + k*N];
	  if(count == 0) continue;
	  if(weight) w = weight[i];
	  m += a[k]*di_pochhammer(a[k], count)*w;
	}
      }
      else {
	double w = 1;
	int index;
	for(index = firstInCol[k]; index < firstInCol[k+1]; index++) {
	  int count = data[index];
	  if(weight) w = weight[rowOf[index]];
	  m += a[k]*di_pochhammer(a[k], count)*w;
	}
      }
      f += m;
      a[k] = m;
    }
    /* renormalize a to sum to s */
    f = s/f;
    for(k=0;k<K;k++) {
      a[k] *= f;
    }

    maxdiff = 0;
    for(k=0;k<K;k++) {
      double diff = fabs(a[k] - old_a[k]);
      if(diff > maxdiff) maxdiff = diff;
    }
    if(maxdiff < 1e-4) break;
  }
}
