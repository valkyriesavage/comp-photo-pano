function refined = refine(cpstruct,baseimg,inputimg)
    function score = scoreAlignment(inputpt,basept,inputimg,baseimg)
        % for this scoring... we can either 
        % a) subtract absolute pixel values
        % b) do edge detection and compare
        % c) compare in gradient space
        % a is simplest to implement so we'll start there
        patchsize = 5;
        inputpatch = inputimg(inputpt(2)-patchsize:inputpt(2)+patchsize,inputpt(1)-patchsize:inputpt(1)+patchsize,:);
        basepatch = baseimg(basept(2)-patchsize:basept(2)+patchsize,basept(1)-patchsize:basept(1)+patchsize,:);
        score = sum(sum(sum(abs(inputpatch-basepatch))));
    end

    inputpts = cpstruct.inputPoints;
    basepts = cpstruct.basePoints;
    
    numpts = size(inputpts,1);
    numbase = size(basepts,1);
    if numpts ~= numbase
        disp('wtf - points counts unequal');
    end
    
    refined = cpstruct;
    
    searchspace = 5;
    
    for p = [1:numpts]
        base = basepts(p,:);
        input = inputpts(p,:);
        
        bestxy = input;
        % we'll score like golf.  lower is better.
        bestscore = 10000;
        
        % let's just shift around a lil bit and see if something
        % nearby matches a little better
        for x_s = [-searchspace:searchspace]
            for y_s = [-searchspace:searchspace]
                test = input+[x_s,y_s];
                score = scoreAlignment(test,base,inputimg,baseimg);
                if score < bestscore
                    bestscore = score;
                    bestxy = test;
                end
            end
        end
        refined.inputPoints(p,:) = bestxy;
    end
    refined.basePoints = basepts;
end