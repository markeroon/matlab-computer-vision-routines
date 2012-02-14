function mt = p2t(H,m);   
%_P2T Applica una trasformazione proiettiva nel 2D.
%
%mt = p2t(H,m) data una omografia H del piano
%proiettivo e un insime di punti immagine m,
%calcola la trasformazione del piano immagine in se 
%stesso.

% Author: Andrea Fusiello

[na,ma]=size(H);
if na~=3 | ma~=3
    error('Formato errato della matrice di trasformazione (3x3)!!');
end

[rml,cml]=size(m);
if (rml ~= 2)
    error('Le coordinate immagine devono essere cartesiane!!');
end


dime = size(m,2);
 
c3d = [m;  ones(1,dime)];
h2d = H * c3d;
c2d = h2d(1:2,:)./ [h2d(3,:)' h2d(3,:)']';

mt = c2d(1:2,:);


