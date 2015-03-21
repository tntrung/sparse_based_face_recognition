#include "mex.h"

class CMatrix
{
private:
    double* x;
    double* y;
public:    
    CMatrix()
    {
        x = 0;
        y = 0;
    }
    
    CMatrix(double* x, double* y)
    {
        this->x = x;
        this->y = y;
    }
    
    ~CMatrix()
    {
        x=y=0;
    }
    
    void TimesTwo()
    {
        *y = 2 * (*x);
    }
};

void timestwo(double y[], double x[]) {
    //y[0] = 2.0*x[0];
    CMatrix* pMatrix  = new CMatrix(x,y);
    pMatrix->TimesTwo();
    delete pMatrix;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
        const mxArray *prhs[]) {
    double *x, *y;
    int mrows, ncols;
    /* Check for proper number of arguments. */
    if (nrhs != 1) {
        mexErrMsgTxt("One input required.");
    } else if (nlhs > 1) {
        mexErrMsgTxt("Too many output arguments");
    }
    
    /* Get the number of elements in the input argument. */
    int elements = mxGetNumberOfElements(prhs[0]);    
    /* The input must be a noncomplex scalar double.*/
    mrows = mxGetM(prhs[0]);
    ncols = mxGetN(prhs[0]);
    double* pr = (double *)mxGetPr(prhs[0]);
    int number_of_dims = mxGetNumberOfDimensions(prhs[0]);        
    /* Get the number of dimensions in the input argument. */
    const int* dim_array = mxGetDimensions(prhs[0]);
    for(int i =0; i<number_of_dims; i++)
    {
        mexPrintf("Dim(%d): %d\n", i+1, dim_array[i]);
    }
    for(int i =0; i<mrows; i++)
    {
        for(int j =0; j<ncols; j++)
        {
            mexPrintf("%4.2f ", pr[i + j*mrows]);
        }
        mexPrintf("\n");
    }
    if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
            !(mrows == 1 && ncols == 1)) {        
        mexPrintf("Elements: %d M: %d, N: %d\n", elements, mrows, ncols);
        mexErrMsgTxt("Input must be a noncomplex scalar double.");
    }
    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
    
    /* Assign pointers to each input and output. */
    x = mxGetPr(prhs[0]);
    y = mxGetPr(plhs[0]);
    
    /* Call the timestwo subroutine. */
    timestwo(y, x);
}