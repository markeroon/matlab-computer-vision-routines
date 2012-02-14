function allines = loaddata(fn)

% LOADDATA      A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

f = fopen(fn);
allines = [];
lastv = [];
while ~feof(f)
  l = fgetl(f);
  v = sscanf(l, '%g');
  if length(v) == 1
    if ~isempty(lastv)
      allines = [ allines ;
	[lastv(3) lastv(4)]
	[nan nan]
	];
    end
  else
    allines = [allines;
      v(1:2)'
      ];
    lastv = v;
  end
end
fclose(f)
