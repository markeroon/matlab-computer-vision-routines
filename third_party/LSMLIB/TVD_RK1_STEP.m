%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TVD_RK1_STEP takes a single first-order Runge-Kutta (i.e.
%              Forward Euler) step.
%
% Usage: u_next = TVD_RK1_STEP(u_cur, rhs, dt)
%
% Arguments:
% - u_cur:       u(t_cur)
% - rhs:         right-hand side of time evolution equation at t_cur
% - dt:          step size
%
% Return value:
% - u_next:      u(t_cur + dt)
%
% NOTES:
% - u_cur and rhs are assumed to have the same dimensions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyrights: (c) 2005 The Trustees of Princeton University and Board of
%                 Regents of the University of Texas.  All rights reserved.
%             (c) 2009 Kevin T. Chu.  All rights reserved.
% Revision:   $Revision: 149 $
% Modified:   $Date: 2009-01-18 00:31:09 -0800 (Sun, 18 Jan 2009) $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u_next = TVD_RK1_STEP(u_cur, rhs, dt)

u_next = u_cur + dt*rhs;
