
function [second_smallest] = getSecondSmallestVal( arr )
 [val,idx] = min( arr );
 arr(idx) = realmax('double');
 second_smallest = min( arr );
end