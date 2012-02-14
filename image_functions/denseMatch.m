	% *************************************************************************
	% Title: Function-Compute Correlation between two images using various
	% similarity measures with Left Image as reference.
	% Author: Siddhant Ahuja
	% Created: March 2010
	% Copyright Siddhant Ahuja, 2010
	% Inputs:
	% 1. Left Image (var: rightImage),
	% 2. Right Image (var: leftImage),
	% 3. Correlation Window Size (var: corrWindowSize),
	% 4. Minimum Disparity in X-direction (var: dMin),
	% 5. Maximum Disparity in X-direction (var: dMax),
	% 6. Method used for calculating the correlation scores (var: method)
	% Valid values include: 'SAD', 'LSAD', 'ZSAD', 'SSD', 'LSSD', ZSSD', 'NCC',
	% 'ZNCC'
	% Outputs:
	% 1. Disparity Map (var: dispMap),
	% 2. Time taken (var: timeTaken)
	% Example Usage of Function: [dispMap, timeTaken]=denseMatch('tsukuba_left.tiff', 'tsukuba_right.tiff', 9, 0, 16, 'ZNCC');
	% *************************************************************************
	function [dispMap, timeTaken]=denseMatch(rightImage, leftImage, corrWindowSize, dMin, dMax, method)
	%{
    % Grab the image information (metadata) of left image using the function imfinfo
	leftImageInfo=imfinfo(leftImage);
	% Grab the image information (metadata) of right image using the function imfinfo
	rightImageInfo=imfinfo(rightImage);
	% Since Dense Matching is applied on a grayscale image, determine if the
	% input left image is already in grayscale or color
	if(getfield(leftImageInfo,'ColorType')=='truecolor')
	% Read an image using imread function, convert from RGB color space to
	% grayscale using rgb2gray function and assign it to variable leftImage
	    leftImage=rgb2gray(imread(leftImage));
	else if(getfield(leftImageInfo,'ColorType')=='grayscale')
	% If the image is already in grayscale, then just read it.
	        leftImage=imread(leftImage);
	    else
	        error('The Color Type of Left Image is not acceptable. Acceptable color types are truecolor or grayscale.');
	    end
	end
	% Since Dense Matching is applied on a grayscale image, determine if the
	% input right image is already in grayscale or color
	if(getfield(rightImageInfo,'ColorType')=='truecolor')
	% Read an image using imread function, convert from RGB color space to
	% grayscale using rgb2gray function and assign it to variable rightImage
	    rightImage=rgb2gray(imread(rightImage));
	else if(getfield(rightImageInfo,'ColorType')=='grayscale')
	% If the image is already in grayscale, then just read it.
	        rightImage=imread(rightImage);
	    else
	        error('The Color Type of Right Image is not acceptable. Acceptable color types are truecolor or grayscale.');
	    end
    end
    %}
	% Find the size (columns and rows) of the left image and assign the rows to
	% variable nrLeft, and columns to variable ncLeft
	[nrLeft,ncLeft] = size(leftImage);
	% Find the size (columns and rows) of the right image and assign the rows to
	% variable nrRight, and columns to variable ncRight
	[nrRight,ncRight] = size(rightImage);
	% Check to see if both the left and right images have same number of rows
	% and columns
	if(nrLeft==nrRight && ncLeft==ncRight)
	else
	    error('Both left and right images should have the same number of rows and columns');
	end
	% Convert the left and right images from uint8 to double
	leftImage=im2double(leftImage);
	rightImage=im2double(rightImage);
	% Check the size of window to see if it is an odd number.
	if (mod(corrWindowSize,2)==0)
	    error('The window size must be an odd number.');
	end
	% Check whether minimum disparity is less than the maximum disparity.
	if (dMin>dMax)
	    error('Minimum Disparity must be less than the Maximum disparity.');
	end
	% Create an image of size nrLeft and ncLeft, fill it with zeros and assign
	% it to variable dispMap
	dispMap=zeros(nrLeft, ncLeft);
	% Find out how many rows and columns are to the left/right/up/down of the
	% central pixel based on the window size
	win=(corrWindowSize-1)/2;
	% The objective of CC, NCC and ZNCC is to maxmize the
	% correlation score, whereas other methods try to minimize
	% it.
	maximize = 0;
	if strcmp(method,'NCC') || strcmp(method,'ZNCC')
	    maximize = 1;
	end
	tic; % Initialize the timer to calculate the time consumed.
	for(i=1+win:1:nrLeft-win)
	    % For every row in Left Image
	    for(j=1+win:1:ncLeft-win-dMax)
	        % For every column in Left Image
	        % Initialize the temporary variable to hold the previous
	        % correlation score
	        if(maximize)
	            prevcorrScore = 0.0;
	        else
	            prevcorrScore = 65532;
	        end
	        % Initialize the temporary variable to store the best matched
	        % disparity score
	        bestMatchSoFar = dMin;
	        for(d=dMin:dMax)
	            % For every disparity value in x-direction
	            % Construct a region with window around central/selected pixel in left image
	            regionLeft=leftImage(i-win : i+win, j-win : j+win);
	            % Construct a region with window around central/selected pixel in right image
	            regionRight=rightImage(i-win : i+win, j+d-win : j+d+win);
	            % Calculate the local mean in left region
	            meanLeft = mean2(regionLeft);
	            % Calculate the local mean in right region
	            meanRight = mean2(regionRight);
	            % Initialize the variable to store temporarily the correlation
	            % scores
	            tempCorrScore = zeros(size(regionLeft));
	            % Calculate the correlation score
	            if strcmp(method,'SAD')
	                tempCorrScore = abs(regionLeft - regionRight);
	            elseif strcmp(method,'ZSAD')
	                tempCorrScore = abs(regionLeft - meanLeft - regionRight + meanRight);
	            elseif strcmp(method,'LSAD')
	                tempCorrScore = abs(regionLeft - meanLeft/meanRight*regionRight);
	            elseif strcmp(method,'SSD')
	                tempCorrScore = (regionLeft - regionRight).^2;
	            elseif strcmp(method,'ZSSD')
	                tempCorrScore = (regionLeft - meanLeft - regionRight + meanRight).^2;
	            elseif strcmp(method,'LSSD')
	                tempCorrScore = (regionLeft - meanLeft/meanRight*regionRight).^2;
	            elseif strcmp(method,'NCC')
	                % Calculate the term in the denominator (var: den)
	                den = sqrt(sum(sum(regionLeft.^2))*sum(sum(regionRight.^2)));
	                tempCorrScore = regionLeft.*regionRight/den;
	            elseif strcmp(method,'ZNCC')
	                % Calculate the term in the denominator (var: den)
	                den = sqrt(sum(sum((regionLeft - meanLeft).^2))*sum(sum((regionRight - meanRight).^2)));
	                tempCorrScore = (regionLeft - meanLeft).*(regionRight - meanRight)/den;
	            end
	            % Compute the final score by summing the values in tempCorrScore,
	            % and store it in a temporary variable signifying the distance
	            % (var: corrScore)
	            corrScore=sum(sum(tempCorrScore));
	            if(maximize)
	                if(corrScore>prevcorrScore)
	                    % If the current disparity value is greater than
	                    % previous one, then swap them
	                    prevcorrScore=corrScore;
	                    bestMatchSoFar=d;
	                end
	            else
	                if (prevcorrScore > corrScore)
	                    % If the current disparity value is less than
	                    % previous one, then swap them
	                    prevcorrScore = corrScore;
	                    bestMatchSoFar = d;
	                end
	            end
	        end
	        % Store the final matched value in variable dispMap
	        dispMap(i,j) = bestMatchSoFar;
	    end
	end
	% Stop the timer to calculate the time consumed.
	timeTaken=toc;
	end


