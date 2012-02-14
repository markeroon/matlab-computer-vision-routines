function phi = ac_div_AOS_2D(phi, g, delta_t, n_iters, ReinitFcn, RenitFcnParams)
% AOS (additive opterator splitting) scheme for solving PDE equations in
% the form of u_t = div(g*u) (or u_t = div(g*u/|Du|)*|Du| if function
% handler for reinitialisation REINITFCN is provided).
% The major advantages of this scheme are (1) always stable for arbitary
% large delta_t; (2) unlike traditional implicit scheme, no need to solve
% matrix inversion iteratively thus to achieve efficiency.
% The implementation is based on Joachim Weickert et al's paper entitled 
% "Efficient and reliable schemes for nonlinear diffusion filtering"

if nargin < 4
    n_iters = 1;
end
if nargin < 5
    ReinitFcn = [];
end

if nargin < 6 || isempty(ReinitFcn)
    RenitFcnParams = {}; 
end


if ndims(phi) ~= 2
    error(sprintf('%s only works for 2D data.', upper(mfilename)));
end

dims = size(phi);
if ~isequal(dims,size(g))
    error('PHI and G must have the same size.');
end

[L1,M1,R1] = div_AOS(g, delta_t);
[L2,M2,R2] = div_AOS(g', delta_t);

for i = 1:n_iters
    phi_n = reshape(ac_tridiagonal_Thomas(L1,M1,R1,phi),dims);
    phi_n = phi_n + ...
        reshape(ac_tridiagonal_Thomas(L2,M2,R2,phi'),dims([2,1]))';
    
    if ~isempty(ReinitFcn)
        phi_n = feval(ReinitFcn, phi_n, RenitFcnParams{:});
    end
    
    phi = phi_n;
end

function [L,M,R] = div_AOS(g,delta_t)
dims = size(g);
tmp = .5*(g(1:end-1,:) + g(2:end,:));
gamma = [tmp; zeros(1,dims(2))];
beta = [zeros(1,dims(2)); tmp];
alpha = gamma + beta;

s = 4*delta_t;
[L,M,R] = ac_tridiagonal_Thomas(2+s*alpha(:), ...
    -s*beta(2:end),-s*gamma(1:end-1));
