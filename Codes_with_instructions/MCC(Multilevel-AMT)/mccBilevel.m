function [thresholdValue] = mccBilevel(img,min,max)
    
    probabiltyDistribtion = img;
    
    % ------------------------ Correlation Calculation -------------------------
    
    correlationBackground = 0;
    correlationFrontground = 0;
    correlation = 0;
    grayValue = 0;
    
    for z = min : max 
    
        %Getting P(s) for each gray value
        totProbS = sum(probabiltyDistribtion(min:z));

        correlationBackground = 0;
        correlationFrontground = 0;

        %Getting total correlation of background( <=gray value)
        for x = min : z
            if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                fractionback = (probabiltyDistribtion(x)/totProbS).^2;
                correlationBackground =  correlationBackground + fractionback;
            end
        end
        
        %Getting total correlation of object( >=gray value)
        for y = z+1 : max
            if probabiltyDistribtion(y) ~= 0 && totProbS ~= 1
                fractionfront = (probabiltyDistribtion(y)/(1 - totProbS)).^2;
                correlationFrontground = correlationFrontground + fractionfront;
            end
        end
    
        %Getting maximum correlation for each gray value and getting that gray
        %value
        if correlationFrontground ~= 0 && correlationBackground ~= 0
                 correlationFrontground = -log(correlationFrontground);
                 correlationBackground = -log(correlationBackground);
                 if correlation < correlationFrontground + correlationBackground
                    correlation = correlationFrontground + correlationBackground;
                    grayValue = z;
                end
        end
    end
    
    %Return threshold value
    thresholdValue = grayValue;
    
end