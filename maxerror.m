function output_value = maxerror( differences, candidateState, modelState)
%maxerror Outputs the maximum error value throughout the components of a
% state vector
%   candidateState  - state after integration
%   modelState - state before integration

% Maybe candidateState is a currently calculated step, modelState - raw
% state without error control

relativeErrorThreshold = 0.1;%1e-13;%0.1;
error = 0.0;
retval = 0.0;
 
   for i=1:6
       %disp(i);
      delta = candidateState(i) - modelState(i);
      if (delta > relativeErrorThreshold)
         error = abs(differences(i) / delta);
      else
         error = abs(differences(i));
      end
      
      if (error > retval)
         retval = error;
      end
   end

   output_value = retval;

end

