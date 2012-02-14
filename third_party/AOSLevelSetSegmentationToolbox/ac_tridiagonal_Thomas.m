function varargout = ac_tridiagonal_Thomas(varargin)

% Example:
%     N = 5;
%     A = diag(randn(1,N)) + diag(randn(1,N-1),-1) + diag(randn(1,N-1),1);
%     [L,M,R] = ac_tridiagonal_Thomas(diag(A), diag(A,1), diag(A,-1));
%     err = (diag(ones(1,N))+diag(L,-1))*(diag(M)+diag(R,1))-A
%     b = rand(N,1);
%     x0 = inv(A)*b;
%     x1 = ac_tridiagonal_Thomas(L,M,R,b);
%     err = x0-x1

if length(varargin) == 3 % do the decomposition
    % input management
    alpha = varargin{1};
    beta = varargin{2};
    gamma = varargin{3};
    N = numel(alpha);
    if numel(beta) ~= N-1 || numel(gamma) ~= N-1
        error('Lengths of the inputs are not consistent!');
    end

    %         % main
    %         r = beta;
    %         m = zeros(1,N);
    %         l = zeros(1,N-1);
    %
    %         m(1) = alpha(1);
    %         for i = 1:N-1
    %             l(i) = gamma(i)/m(i);
    %             m(i+1) = alpha(i+1) - l(i)*beta(i);
    %         end
    %         % output management
    %         varargout{1} = l;
    %         varargout{2} = m;
    %         varargout{3} = r;

    [varargout{1},varargout{2},varargout{3}] = ...
        ac_tridiagonal_Thomas_dll(alpha, beta, gamma);

elseif length(varargin) == 4 % do the solution
    % input management
    l = varargin{1};
    m = varargin{2};
    r = varargin{3};
    d = varargin{4};

    N = numel(d);
    if numel(m) ~= N || numel(l) ~= N-1 || numel(r) ~= N-1
        error('Lengths of the inputs are not consistent!');
    end

    %         % main
    %         % forward substitution
    %         y = zeros(N,1);
    %         y(1) = d(1);
    %         for i = 2:N
    %             y(i) = d(i)-l(i-1)*y(i-1);
    %         end
    %
    %         % backward substitution
    %         l(N) = y(N)/m(N);
    %         for i = N-1:-1:1
    %             l(i) = (y(i)-r(i)*l(i+1))/m(i);
    %         end
    %
    %         % output
    %         varargout{1} = l;

    varargout{1} = ac_tridiagonal_Thomas_dll(l,m,r,d);
end