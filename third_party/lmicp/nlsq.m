function [x,CostFunction,JAC,EXITFLAG,OUTPUT,msg] = nlsq(funfcn,x,verbosity,options,defaultopt,CostFunction,JAC,YDATA,caller,varargin)
%NLSQ Solves non-linear least squares problems.
%   NLSQ is the core code for solving problems of the form:
%   min  sum {FUN(X).^2}    where FUN and X may be vectors or matrices.   
%             x
%

%   Copyright 1990-2000 The MathWorks, Inc.
%   $Revision: 1.20 $  $Date: 2000/06/16 22:12:37 $
%   Andy Grace 7-9-90.

%   The default algorithm is the Levenberg-Marquardt method with a 
%   mixed quadratic and cubic line search procedure.  A Gauss-Newton
%   method is selected by setting  OPTIONS.LevenbergMarq='on'. 
%

% ------------Initialization----------------

'OInlsq';

% Initialization
XOUT = x(:);
% numberOfVariables must be the name of this variable
numberOfVariables = length(XOUT);
msg = [];
how = [];
numFunEvals = 0;
numGradEvals = 0;
OUTPUT = [];
iter = 0;
EXITFLAG = 1;  %assume convergence
currstepsize = 0;
% Global parameters for outside control of leastsq
% OPT_STOP is used for prematurely stopping the optimization
% OPT_STEP is set to 1 during major (non-gradient finding) iterations
%          set to 0 during gradient finding and 2 during line search
%          this can be useful for plotting etc.
global OPT_STOP OPT_STEP;
OPT_STEP = 1;
OPT_STOP = 0;
formatstr=' %5.0f       %5.0f   %13.6g %12.3g %12.3g  ';

% options
gradflag =  strcmp(optimget(options,'Jacobian',defaultopt,'fast'),'on');
tolX = optimget(options,'TolX',defaultopt,'fast');
lineSearchType = strcmp(optimget(options,'LineSearchType',defaultopt,'fast'),'cubicpoly');
levMarq = strcmp(optimget(options,'LevenbergMarquardt',defaultopt,'fast'),'on');
tolFun = optimget(options,'TolFun',defaultopt,'fast');
DiffMinChange = optimget(options,'DiffMinChange',defaultopt,'fast');
DiffMaxChange = optimget(options,'DiffMaxChange',defaultopt,'fast');
DerivativeCheck = strcmp(optimget(options,'DerivativeCheck',defaultopt,'fast'),'on');
maxFunEvals = optimget(options,'MaxFunEvals',defaultopt,'fast');
maxIter = optimget(options,'MaxIter',defaultopt,'fast');
if ischar(maxFunEvals)
   if isequal(lower(maxFunEvals),'100*numberofvariables')
      maxFunEvals = 100*numberOfVariables;
   else
      error('Option ''MaxFunEvals'' must be an integer value if not the default.')
   end
end


nfun=length(CostFunction);
iter = 0;
numFunEvals = 0;
numGradEvals = 0;
MATX=zeros(3,1);
MATL=[CostFunction'*CostFunction;0;0];
FIRSTF=CostFunction'*CostFunction;
[OLDX,OLDF]=lsinit(XOUT,CostFunction,verbosity,levMarq);
PCNT = 0;
EstSum=0.5;
% system of equations or overdetermined
if nfun >= numberOfVariables
   GradFactor = 0;  
else % underdetermined: singularity in JAC'*JAC or GRAD*GRAD' 
   GradFactor = 1;
end
CHG = 1e-7*abs(XOUT)+1e-7*ones(numberOfVariables,1);
status=-1;

OPT_STEP = 0;  % No longer a major step

DiffMaxChange
DiffMinChange

while status~=1  & OPT_STOP == 0
   iter = iter + 1;
   % Work Out Gradients
   if ~(gradflag) | DerivativeCheck
      JACFD = zeros(nfun, numberOfVariables);  % set to correct size
      OLDF=CostFunction;
      CHG = sign(CHG+eps).*min(max(abs(CHG),DiffMinChange),DiffMaxChange);
      for gcnt=1:numberOfVariables
         temp = XOUT(gcnt);
         XOUT(gcnt) = temp +CHG(gcnt);
         x(:) = XOUT;
         CostFunction = feval(funfcn{3},x,varargin{:});  
         if ~isempty(YDATA)
            CostFunction = CostFunction - YDATA;
         end
         CostFunction = CostFunction(:);
         OPT_STEP = 0; % We're in gradient finding mode
         JACFD(:,gcnt)=(CostFunction-OLDF)/(CHG(gcnt));
         XOUT(gcnt) = temp;
      end
      CostFunction = OLDF;
      numFunEvals=numFunEvals+numberOfVariables;
      % Gradient check
      if DerivativeCheck == 1 & gradflag
         
         if isa(funfcn{3},'inline') 
            % if using inlines, the gradient is in funfcn{4}
            graderr(JACFD, JAC, formula(funfcn{4})); %
         else 
            % otherwise fun/grad in funfcn{3}
            graderr(JACFD, JAC,  funfcn{3});
         end
         DerivativeCheck = 0;
      else
         JAC = JACFD;
      end
   else
      x(:) = XOUT;
   end
   
   % Try to set difference to 1e-8 for next iteration
   if nfun==1  % JAC is a column vector or scalar, don't sum over rows
      sumabsJAC = abs(JAC);
   else  % JAC is a row vector or matrix
      sumabsJAC = sum(abs(JAC)')';  % Sum over the rows of JAC
   end
   nonZeroSum = (sumabsJAC~=0);
   CHG(~nonZeroSum) = Inf;  % to avoid divide by zero error
   CHG(nonZeroSum) = nfun*1e-8./sumabsJAC(nonZeroSum);
   
   OPT_STEP = 2; % Entering line search    
   
   GradF = 2*(CostFunction'*JAC)'; %2*GRAD*CostFunction;
   NewF = CostFunction'*CostFunction;
   %---------------Initialization of Search Direction------------------
   if status==-1
      if cond(JAC)>1e8 
%         SD=-(GRAD*GRAD'+(norm(GRAD)+1)*(eye(numberOfVariables,numberOfVariables)))\(GRAD*CostFunction);
         SD=-(JAC'*JAC+(norm(JAC)+1)*(eye(numberOfVariables,numberOfVariables)))\(CostFunction'*JAC)';
         if levMarq 
            GradFactor=norm(JAC)+1; 
         end
         how='COND';
      else
         % SD=JAC\(JAC*X-F)-X;
         SD=-(JAC'*JAC+GradFactor*(eye(numberOfVariables,numberOfVariables)))\(CostFunction'*JAC)';
      end
      FIRSTF=NewF;
      OLDJ = JAC;
      GDOLD=GradF'*SD;
      % currstepsize controls the initial starting step-size.
      % If currstepsize has been set externally then it will
      % be non-zero, otherwise set to 1.
      if currstepsize == 0, 
         currstepsize=1; 
      end
      if verbosity>1
         disp(sprintf(formatstr,iter,numFunEvals,NewF,currstepsize,GDOLD));
      end
      XOUT=XOUT+currstepsize*SD;
      if levMarq
         newf=JAC*SD+CostFunction;
         GradFactor=newf'*newf;
         SD=-(JAC'*JAC+GradFactor*(eye(numberOfVariables,numberOfVariables)))\(CostFunction'*JAC)'; 
      end
      newf=JAC*SD+CostFunction;
      XOUT=XOUT+currstepsize*SD;
      EstSum=newf'*newf;
      status=0;
      if lineSearchType==0; 
         PCNT=1; 
      end
      
   else
      %-------------Direction Update------------------
      gdnew=GradF'*SD;
      if verbosity> 1 
         num=sprintf(formatstr,iter,numFunEvals,NewF,currstepsize,gdnew);
      end
      if gdnew>0 & NewF>FIRSTF
         % Case 1: New function is bigger than last and gradient w.r.t. SD -ve
         % ... interpolate. 
         how='inter';
         [stepsize]=cubici1(NewF,FIRSTF,gdnew,GDOLD,currstepsize);
         currstepsize=0.9*stepsize;
      elseif NewF<FIRSTF
         %  New function less than old fun. and OK for updating 
         %         .... update and calculate new direction. 
         [newstep,fbest] =cubici3(NewF,FIRSTF,gdnew,GDOLD,currstepsize);
         if fbest>NewF,
            fbest=0.9*NewF; 
         end 
         if gdnew<0
            how='incstep';
            if newstep<currstepsize,  
               newstep=(2*currstepsize+1e-4); how=[how,'IF']; 
            end
            currstepsize=abs(newstep);
         else 
            if currstepsize>0.9
               how='int_step';
               currstepsize=min([1,abs(newstep)]);
            end
         end
         % SET DIRECTION.      
         % Gauss-Newton Method    
         temp=1;
         if ~levMarq
            if currstepsize>1e-8 & cond(JAC)<1e8
               SD=JAC\(JAC*XOUT-CostFunction)-XOUT;
               if SD'*GradF>eps,
                  how='ERROR- GN not descent direction';
               end
               temp=0;
            else
               if verbosity > 0
                  disp('Conditioning of Gradient Poor - Switching To LM method')
               end
               how='CHG2LM';
               levMarq=1;
               currstepsize=abs(currstepsize);               
            end
         end
         
         if (temp)      
            % Levenberg_marquardt Method N.B. EstSum is the estimated sum of squares.
            %                                 GradFactor is the value of lambda.
            % Estimated Residual:
            if EstSum>fbest
               GradFactor=GradFactor/(1+currstepsize);
            else
               GradFactor=GradFactor+(fbest-EstSum)/(currstepsize+eps);
            end
            SD=-(JAC'*JAC+GradFactor*(eye(numberOfVariables,numberOfVariables)))\(CostFunction'*JAC)'; 
            currstepsize=1; 
            estf=JAC*SD+CostFunction;
            EstSum=estf'*estf;
            if verbosity> 1
               num=[num,sprintf('%12.6g ',GradFactor)]; 
            end
         end
         gdnew=GradF'*SD;
         
         OLDX=XOUT;
         % Save Variables
         FIRSTF=NewF;
         OLDG=GradF;
         GDOLD=gdnew;    
         
         % If quadratic interpolation set PCNT
         if lineSearchType==0, 
            PCNT=1; MATX=zeros(3,1); MATL(1)=NewF; 
         end
      else 
         % Halve Step-length
         how='Red_Step';
         if NewF==FIRSTF,
            if verbosity>0
               msg = sprintf('No improvement in search direction: Terminating');
            end
            status=1;
            EXITFLAG = -1;
         else
            currstepsize=currstepsize/8;
            if currstepsize<1e-8
               currstepsize=-currstepsize;
            end
         end
      end
      XOUT=OLDX+currstepsize*SD;
      if isinf(verbosity)
         disp([num,'       ',how])
      elseif verbosity>1
         disp(num)
      end
      
   end %----------End of Direction Update-------------------
   if lineSearchType==0, 
      PCNT=1; MATX=zeros(3,1);  MATL(1)=NewF; 
   end
   % Check Termination 
   if max(abs(SD))< tolX 
      if verbosity > 0
         msg = sprintf('Optimization terminated successfully: \n Search direction less than tolX');     
      end
      status=1; EXITFLAG=1;
   elseif (GradF'*SD) < tolFun & ...
         max(abs(GradF)) < 10*(tolFun+tolX)
      if verbosity > 0
         msg = sprintf(['Optimization terminated successfully:\n Gradient in the search direction less than tolFun\n',... 
                        ' Gradient less than 10*(tolFun+tolX)']);
      end
      status=1; EXITFLAG=1;

   elseif numFunEvals > maxFunEvals
      if verbosity>0
         msg = sprintf(['Maximum number of function evaluations exceeded\n',...
                 'Increase OPTIONS.maxFunEvals']);
      end
      status=1;
      EXITFLAG = 0;
   elseif iter > maxIter
      if verbosity>0
         msg = sprintf(['Maximum number of iterations exceeded\n', ...
                        'Increase OPTIONS.iterations']);
      end
      status=1;
      EXITFLAG = 0;
   else
      % Line search using mixed polynomial interpolation and extrapolation.
      if PCNT~=0
         % initialize OX and OLDF 
         OX = XOUT; OLDF = CostFunction;
         while PCNT > 0 & OPT_STOP == 0 & numFunEvals <= maxFunEvals
            x(:) = XOUT; 
            CostFunction = feval(funfcn{3},x,varargin{:});
            if ~isempty(YDATA)
               CostFunction = CostFunction - YDATA;
            end
            CostFunction = CostFunction(:);
            numFunEvals=numFunEvals+1;
            NewF = CostFunction'*CostFunction;
            % <= used in case when no improvement found.
            if NewF <= OLDF'*OLDF, 
               OX = XOUT; 
               OLDF=CostFunction; 
            end
            [PCNT,MATL,MATX,steplen,NewF,how]=searchq(PCNT,NewF,OLDX,MATL,MATX,SD,GDOLD,currstepsize,how);
            currstepsize=steplen;
            XOUT=OLDX+steplen*SD;
            if NewF==FIRSTF,  
               PCNT=0; 
            end
         end % end while
         XOUT = OX;
         CostFunction=OLDF;
         if numFunEvals>maxFunEvals 
            if verbosity > 0
                msg = sprintf(['Maximum number of function evaluations exceeded\n',...
                            'Increase OPTIONS.maxFunEvals']);
            end              
            status=1; 
            EXITFLAG = 0;
         end
      end % if PCNT~=0
   end % if max
   OPT_STEP = 1; % Call the next iteration a major step for plotting etc.
   
   x(:)=XOUT; 
   switch funfcn{1}
   case 'fun'
      CostFunction = feval(funfcn{3},x,varargin{:});
      if ~isempty(YDATA)
         CostFunction = CostFunction - YDATA;
      end
      CostFunction = CostFunction(:);
      nfun=length(CostFunction);
      % JAC will be updated when it is finite-differenced
   case 'fungrad'
      [CostFunction,JAC] = feval(funfcn{3},x,varargin{:});
      if ~isempty(YDATA)
         CostFunction = CostFunction - YDATA;
      end
      CostFunction = CostFunction(:);
      numGradEvals=numGradEvals+1;
   case 'fun_then_grad'
      CostFunction = feval(funfcn{3},x,varargin{:}); 
      if ~isempty(YDATA)
         CostFunction = CostFunction - YDATA;
      end
      CostFunction = CostFunction(:);
      JAC = feval(funfcn{4},x,varargin{:});
      numGradEvals=numGradEvals+1;
   otherwise
      error('Undefined calltype in LSQNONLIN');
   end
   numFunEvals=numFunEvals+1;
      
end  % while


XOUT=OLDX;
x(:)=XOUT;

OUTPUT.iterations = iter;
OUTPUT.funcCount = numFunEvals;
OUTPUT.stepsize=currstepsize;
OUTPUT.cgiterations = [];
OUTPUT.firstorderopt = [];

if levMarq
   OUTPUT.algorithm='medium-scale: Levenberg-Marquardt, line-search';
else
   OUTPUT.algorithm='medium-scale: Gauss-Newton, line-search';
end

%--end of leastsq--


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xold,fold,how]=lsinit(xnew,fnew,verbosity,levMarq)
%LSINT  Function to initialize NLSQ routine.

%   $Revision: 1.20 $  $Date: 2000/06/16 22:12:37 $
%   Andy Grace 7-9-90.
xold=xnew;
fold=fnew;



if verbosity>1
   
   if ~levMarq
      if isinf(verbosity)
         header = sprintf(['\n                                                     Directional \n',...
                             ' Iteration  Func-count    Residual     Step-size      derivative   Line-search']);
      else
         header = sprintf(['\n                                                     Directional \n',...
                             ' Iteration  Func-count    Residual     Step-size      derivative ']);
      end
   else
      if isinf(verbosity)
         header = sprintf(['\n                                                     Directional \n',...
                             ' Iteration  Func-count    Residual     Step-size      derivative   Lambda       Line-search']);
      else
         header = sprintf(['\n                                                     Directional \n',...
                             ' Iteration  Func-count    Residual     Step-size      derivative    Lambda']);
      end
   end
   disp(header)
end

