function [F,el,er] = fund(pml,pmr)
%FUND Computes fundamental matrix and epipoles from camera matrices.
%
%[F,el,er] = fund(pml,pmr) calcola la matrice fondamentale
%F, l'epipolo sinistro el e destro er, partendo dalle due 
%matrici  di proiezione prospettica pml (MPP sinistra) e 
%pmr (MPP destra).

%    Author: A. Fusiello 1999


%calcolo i centri ottici dalle due MPP
cl = -inv(pml(:,1:3))*pml(:,4);
cr = -inv(pmr(:,1:3))*pmr(:,4);

%calcolo gli epipoli come proiezione dei centri
%ottici
el = pml*[cr' 1]';
er = pmr*[cl' 1]';

%el = el./norm(el);
%er = er./norm(er);

%calcolo la matrice fondamentale
F=[   0    -er(3)  er(2)
     er(3)    0   -er(1)
    -er(2)  er(1)   0   ]*pmr(:,1:3)*inv(pml(:,1:3));


F = F./norm(F);

