function icp_pngprint(fn)

% ICP_PNGPRINT  A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

global icp_pngprint_glob

if icp_pngprint_glob.mode == 1
  fn = sprintf(icp_pngprint_glob.fn, icp_pngprint_glob.count);
  icp_pngprint_glob.count = icp_pngprint_glob.count+1;

  icp_thicken(findobj('type', 'line'));
  drawnow;
    
  printf('[print %s]', fn);
  print('-dpng', '-r72', fn)
else
  
  icp_thicken(findobj('type', 'line'));
  drawnow;
    
  printf('[print %s]', fn);
  print('-dpng', '-r72', fn)
end
