function phi = ac_div_AOS_1D(phi, g, delta_t, n_iters, ReinitFcn, RenitFcnParams)
% AOS (additive opterator splitting) scheme for solving PDE equations in
% the form of u_t = div(g*u) (or u_t = div(g*u/|Du|)*|Du| if function
% handler for reinitialisation REINITFCN is provided).
% The major advantages of this scheme are (1) always stable for arbitary
% large delta_t; (2) unlike traditional implicit scheme, no need to solve
% matrix inversion iteratively thus to achieve efficiency.
% The implementation is based on Joachim Weickert et al's paper entitled 
% "Efficient and reliable schemes for nonlinear diffusion filtering"
% g is assumed to be constant in each iteration.

if nargin < 4
    n_iters = 1;
end
if nargin < 5
    ReinitFcn = [];
end
if nargin < 6 || isempty(ReinitFcn)
    RenitFcnParams = {}; 
end

if numel(phi) ~= max(size(phi))
    error('%s only works for 1D data.', upper(mfilename));
end

dims = size(phi);
if ~isequal(dims,size(g))
    error('PHI and G must have the same size.');
end


[L,M,R] = div_AOS(g, delta_t);

for i = 1:n_iters
    phi_n = reshape(ac_tridiagonal_Thomas(L,M,R,phi),dims);
    
    if ~isempty(ReinitFcn)
        phi_n = feval(ReinitFcn, phi_n, RenitFcnParams{:});
    end
    
    phi = phi_n;
end

function [L,M,R] = div_AOS(g,delta_t)
tmp = .5*(g(1:end-1) + g(2:end));
% gamma = [tmp, 0];
% beta = [0, tmp];
gamma = zeros(size(g));
gamma(1:end-1) = tmp;
beta = zeros(size(g));
beta(2:end) = tmp;
alpha = gamma + beta;

s = delta_t;
[L,M,R] = ac_tridiagonal_Thomas(1+s*alpha, ...
    -s*beta(2:end),-s*gamma(1:end-1));
