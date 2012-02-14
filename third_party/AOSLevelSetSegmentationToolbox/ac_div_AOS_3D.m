function phi = ac_div_AOS_3D(phi, g, delta_t, n_iters, ReinitFcn, RenitFcnParams, mex_version)
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
if nargin < 7
    mex_version = 1; % use the kernal in C version.
end

if ndims(phi) ~= 3
    error('%s only works for 3D data.', upper(mfilename));
end

dims = size(phi);
if ~isequal(dims,size(g))
    error('PHI and G must have the same size.');
end

if ~mex_version
    % This implementation sucks, I know. But for 3D case, sometimes I have to
    % compensate efficiency for memory. (2007/06)
    phi_n = zeros(dims);
    for i = 1:n_iters
        for j = 1:dims(1)
            for k = 1:dims(2)
                [L,M,R] = div_AOS_1D(g(j,k,:), delta_t);
                phi_n(j,k,:) = ac_tridiagonal_Thomas(L,M,R,phi(j,k,:));
            end
        end

        for j = 1:dims(1)
            for k = 1:dims(3)
                [L,M,R] = div_AOS_1D(g(j,:,k), delta_t);
                phi_n(j,:,k) = phi_n(j,:,k) + ...
                    ac_tridiagonal_Thomas(L,M,R,phi(j,:,k))';
            end
        end

        for j = 1:dims(2)
            for k = 1:dims(3)
                [L,M,R] = div_AOS_1D(g(:,j,k), delta_t);
                phi_n(:,j,k) = phi_n(:,j,k) + ...
                    ac_tridiagonal_Thomas(L,M,R,phi(:,j,k));
            end
        end

        if ~isempty(ReinitFcn)
            phi_n = feval(ReinitFcn, phi_n, RenitFcnParams{:});
        end

        phi = phi_n;
    end
else
    % Finally, a much more efficient implementation in C has been
    % developed. (2007/08)
    for i = 1:n_iters
        phi_n = ac_div_AOS_3D_dll(phi, g, delta_t);

        if ~isempty(ReinitFcn)
            phi_n = feval(ReinitFcn, phi_n, RenitFcnParams{:});
        end

        phi = phi_n;
    end
end

function [L,M,R] = div_AOS_1D(g,delta_t)
tmp = .5*(g(1:end-1) + g(2:end));
% gamma = [tmp, 0];
% beta = [0, tmp];
gamma = zeros(size(g));
gamma(1:end-1) = tmp;
beta = zeros(size(g));
beta(2:end) = tmp;
alpha = gamma + beta;

s = 9*delta_t;
[L,M,R] = ac_tridiagonal_Thomas(3+s*alpha, ...
    -s*beta(2:end),-s*gamma(1:end-1));