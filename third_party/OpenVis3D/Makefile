CC = g++
INC = -I /usr/include/opencv
CCFLAGS = -g -Wall $(INC)
LDFLAGS = -L /usr/lib -L . -lm -lcv0.9 -lhighgui0.9 -lcvaux0.9
SRC = OpencvExample.cpp OvImageAdapter.cpp OpenCVImageAdapter.cpp
OBJS = $(SRC:.cpp=.o)

.cpp.o:
	$(CC) $(CCFLAGS) -c $<

.o:
	$(CC) $(CCFLAGS) $(LDFLAGS) $^ -o $@

OpencvExample: $(OBJS)
all: OpencvExample
clean:
	rm -f $(OBJS) OpencvExample

#
# The lines below were auto-generated using g++ -MM *.cpp
#
OpenCVImageAdapter.o: OpenCVImageAdapter.cpp OpenCVImageAdapter.h \
  OvImageAdapter.h
OvImageAdapter.o: OvImageAdapter.cpp OvImageAdapter.h
OpencvExample.o: OpencvExample.cpp Openvis3d.h OvImageAdapter.h \
  OvImageT.h OvImagePairPreprocessorT.h OvLocalMatcherT.h \
  OvStereoGlobalMatcherT.h OvDisparityPostprocessor.h \
  OvFlowGlobalMatcherT.h OvFlowPostprocessor.h OvStereoT.h \
  OvFlowT.h BTLocalMatcherT.h \
  OvStereoDiffuseMatcherT.h \
  OvFlowDiffuseMatcherT.h OpenCVImageAdapter.h
