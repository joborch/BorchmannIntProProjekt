function [library] = createLib(NBack, arrayCount, hitPos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if NBack == 0
    library = cell(6,1);
    i=1;
    while i <= 6
        ind(1,:) = randi([1, 8], 1, 10);
        ind(2,:) = zeros(1,10);
    
        hit = 0;
        for j = 1:10
            if ind(1,j) == hitPos
                hit = hit + 1;
                ind(2,j) = 1;
            end
        end
        if hit == 3
            if i>1
                for k = 1:i
                    if ind == library{k}
                        disp("Abbruch");
                        break;
                    else
                        disp("saved");
                        library{i} = ind;
                        i = i+1;
                        break;
                    end
                end
            elseif i==1
                disp("saved");
                library{i} = ind;
                i = i+1;        
            end
        end
    end    
else
    library = cell(arrayCount,1);
    i=1;

    while i <= arrayCount
        ind(1,:) = randi([1, 8], 1, 20);
        ind(2,:) = zeros(1,20);

        rep = 0;
        for j = (NBack+1):(20)
            if ind(1,j) == ind(1,j-NBack)
                rep = rep + 1;
                ind(2,j) = 1;
            end
        end
        if rep == 5
            if i>1
                for k = 1:i
                    if ind == library{k}
                        disp("Abbruch");
                        break;
                    else
                        disp("saved");
                        library{i} = ind;
                        i = i+1;
                        break;
                    end
                end
            elseif i==1
                disp("saved");
                library{i} = ind;
                i = i+1;        
            end
        end
    end
end
end