#include "mex.h"

void ac_tridiagonal_Thomas_decomposition(double* alpha, double* beta, double* gamma, 
										 double* l, double* m, double* r, unsigned long N)
{
	m[0] = alpha[0];
	for(unsigned long int i=0; i<N-1; i++)
	{
		r[i] = beta[i];
		l[i] = gamma[i]/m[i];
		m[i+1] = alpha[i+1] - l[i]*beta[i];
	}
}

void ac_tridiagonal_Thomas_solution(double* l, double* m, double* r, double* d, 
									double* y, unsigned long N)
{
	unsigned long i,idx;
	double *yy = new double[N];

//	%     % main
//%     % forward substitution
//%     y = zeros(N,1);
//%     y(1) = d(1);
//%     for i = 2:N
//%         y(i) = d(i)-l(i-1)*y(i-1);
//%     end
//% 
//%     % backward substitution
//%     l(N) = y(N)/m(N);
//%     for i = N-1:-1:1
//%         l(i) = (y(i)-r(i)*l(i+1))/m(i);
//%     end
//
//%     % output
//%     varargout{1} = l;
    
	// forward
	yy[0] = d[0];
	for( i = 1; i<N; ++i)
		yy[i] = d[i] - l[i-1]*yy[i-1];

	// backward
	y[N-1] = yy[N-1]/m[N-1];
	for( i = N-1; i > 0; i--)
	{
		idx = i-1;
		y[idx] = (yy[idx] - r[idx]*y[idx+1])/m[idx];
	}

	delete [] yy;
}

void mexFunction(
	int nlhs,              // Number of left hand side (output) arguments
	mxArray *plhs[],       // Array of left hand side arguments
	int nrhs,              // Number of right hand side (input) arguments
	const mxArray *prhs[]  // Array of right hand side arguments
)
{

	if( nrhs == 4) // do the solution of linear system.
	{
		double *l = mxGetPr(prhs[0]);
		double *m = mxGetPr(prhs[1]);
		double *r = mxGetPr(prhs[2]);
		double *d = mxGetPr(prhs[3]);
		unsigned long N = mxGetN(prhs[3])*mxGetM(prhs[3]);

		plhs[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
		double *y = mxGetPr(plhs[0]);

		ac_tridiagonal_Thomas_solution(l, m, r, d, y, N);
	}
	else 
	{
		if( nrhs == 3) // do the decomposition.
		{
			// Note m and l should be allocated outside the function
			double *alpha = mxGetPr(prhs[0]);
			double *beta = mxGetPr(prhs[1]);
			double *gamma = mxGetPr(prhs[2]);
			unsigned long N = mxGetN(prhs[0])*mxGetM(prhs[0]);

			plhs[0] = mxCreateDoubleMatrix(N-1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(N, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(N-1, 1, mxREAL);
			double* l = mxGetPr(plhs[0]);
			double* m = mxGetPr(plhs[1]);
			double* r = mxGetPr(plhs[2]);

			ac_tridiagonal_Thomas_decomposition(alpha, beta, gamma, l, m, r, N);
		}
	}
} 