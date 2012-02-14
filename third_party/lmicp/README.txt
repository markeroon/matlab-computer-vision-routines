
Files from the paper "Robust Registration of 2D and 3D Point Sets".

@InProceedings{Fitzgibbon2001c,
        author = "Fitzgibbon, A.~W.",
	title = "Robust Registration of 2D and 3D Point Sets",
	booktitle = bmvc,
	year = 2001,
        pages = "662--670",
        url = "http://www.robots.ox.ac.uk/~vgg/vggpapers/Fitzgibbon01c.pdf",
}

COMPILING THE DISTANCE TRANSFORM MODULE

If you're not on windows, you'll need to compile icp_3ddt.cxx
to produce icp_3ddt.exe.

 g++ -o icp_3ddt.exe icp_3ddt.cxx

*should* work -- it works on a linux machine near me.

TESTING

run matlab, cd to this directory and type "demo3d"

You should see a blue bunny approaching a red bunny.


