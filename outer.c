/* Computes kron(a,b)*r, where r is the invdiag matrix.
 * In other words, c(:,j) = kron(a(:,j), b(:,j)).
 */
/* test in matlab:
     a = rand(2,3);  b = rand(3, 3);
     kron(b(:,2), a(:,2))
     outer(a, b)
 */
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
  int r1, r2, c;
  double *a, *b, *result;
  int i,j,k;

  if(nrhs != 2) {
    mexErrMsgTxt("Usage: c = outer(a, b)");
  }

  r1 = mxGetM(prhs[1]);
  c = mxGetN(prhs[1]);
  r2 = mxGetM(prhs[0]);
  if(mxGetN(prhs[0]) != c) {
    mexErrMsgTxt("Inputs must have the same number of columns");
  }
  a = mxGetPr(prhs[1]);
  b = mxGetPr(prhs[0]);
  plhs[0] = mxCreateDoubleMatrix(r1*r2, c, mxREAL);
  result = mxGetPr(plhs[0]);

  /* Loop columns */
  for(k=0; k<c; k++) {
    /* Matlab stores matrices column-major. */
    double *ac = a + k*r1;
    double *bc = b + k*r2;
    double *rc = result + k*r1*r2;
    /* Loop a rows, then b rows */
    for(i=0; i<r1; i++) {
      for(j=0; j<r2; j++) {
	rc[i*r2 + j] = ac[i] * bc[j];
      }
    }
  }
}
