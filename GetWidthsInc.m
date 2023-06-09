function widths = GetWidthsInc(start,step, mask_atr, numBlobs)
%GETWIDTHS Summary of this function goes here
%   Detailed explanation goes here
%   INPUTS:
% start - starting point of measurements on the skeleton
% step - measurement distances
% mask_atr - struct with all attributes
%   OUTPUTS:
% widths - obtained widths at the measurement points


widths_good = [];

% 1. for each occurrence of the membrane in the image
for i = 1:numBlobs
    skel_pix = regionprops(mask_atr(i).skel, "PixelList");
    skel_pix = skel_pix.PixelList;
    skel_len = length(skel_pix);
    stop = skel_len-start; 
    mask = mask_atr(i).mask;

    % Show plots
    figure,
    imshow(mask)
    hold on
    
    flag = 0;

     % 2. sliding along the skeleton to determine the points before and after
    for s=start:step:stop
        x = skel_pix(s,1); y = skel_pix(s,2);

        % 3. find adjacent points on the skeleton  
        x_l = skel_pix(s-10,1); y_l = skel_pix(s-10,2);
        x_p = skel_pix(s+10,1); y_p = skel_pix(s+10,2); 

        if abs(y_l - y_p) > 30
                x_l = skel_pix(s-2,1); y_l = skel_pix(s-2,2);
                x_p = skel_pix(s+2,1); y_p = skel_pix(s+2,2);
        end

       
        % 4. finding the angle of inclination
       slope = (y_l - y_p)./(x_l - x_p);
       perSlope = -1/slope;
       perTheta = atan(perSlope);
        
       % 5. mark a point on the skeleton
       plot(x,y, 'r*')
       

       % 6. distances from both edges 
       len_1 = 0;
       len_2 = 0;
       len_of_membrane=0;
       len1_f = 0;
       len2_f = 0;
       
       % searching for locations from the measurement point to the edge of the mask or image
       for L = 1:stop
            lineLength = L; 
       
            % new coordinates
            newX = [x + lineLength * cos(perTheta), x - lineLength * cos(perTheta)];
            newY = [y + lineLength * sin(perTheta), y - lineLength * sin(perTheta)];
            
            x1 = round(newX(1)); x2= round(newX(2));
            y1 = round(newY(1)); y2 = round(newY(2));

            % checking that the calculated values are suitable - that they are not outside the edges of the image
            if x1 <= 0
                x1 =1;
            elseif x2 <= 0
                x2 = 1;
            elseif y1 <= 0
                y1 =1;
            elseif y2<=0
                y2=1;
            end

            arr_bounds = size(mask);
            if x1 >arr_bounds(2)
                x1 =arr_bounds(2)-1;
            elseif x2 > arr_bounds(2)
                x2 = arr_bounds(2)-1;
            elseif y1 > arr_bounds(1)
                y1 =arr_bounds(1)-1;
            elseif y2 > arr_bounds(1)
                y2=arr_bounds(1)-1; 
            end

            % check 1 point
            if mask(y1, x1) == 0 && len1_f == 0
                %cutPoint1 = [y1, x1];
                len_1 = sqrt((x-x1)^2+(y-y1)^2);
                len1_f = 1;
                if y1 >= arr_bounds(1) || x1 >= arr_bounds(1)
                    flag=1;
                    plot([newX(1), newX(2)], [newY(1), newY(2)], 'g-');
                end
            end
            % check 2 point
            if mask(y2, x2) == 0 && len2_f == 0
                %cutPoint2 = [y2, x2];
                len_2 = sqrt((x-x2)^2+(y-y2)^2);
                len2_f = 1;
                if y2 >= arr_bounds(1) || x2 >= arr_bounds(1)
                    flag=1;
                    plot([newX(1), newX(2)], [newY(1), newY(2)], 'g-');
                end
            end
            % calculation of membrane width
            if len1_f ~= 0 || len2_f ~= 0 
                if len1_f == 0 
                    lL = lineLength + 5;
                    newX = [x + lL * cos(perTheta), x - lL * cos(perTheta)];
                    newY = [y + lL * sin(perTheta), y - lL * sin(perTheta)];
                    x1 = round(newX(1));
                    y1 = round(newY(1)) ;
                    if x1 <= arr_bounds(2)-10 && y1 <= arr_bounds(1)-10  && x1 >0 && y1 >0
                        if mask(y1, x1) == 0 
                            len_1 = sqrt((x-x1)^2+(y-y1)^2);
                        else
                            flag=1;
                            plot([newX(1), newX(2)], [newY(1), newY(2)], 'g-');
                        end
                    else
                        flag=1;
                        plot([newX(1), newX(2)], [newY(1), newY(2)], 'g-');
                    end
                
                end

                if len2_f == 0 
                    lL = lineLength + 5;
                    newX = [x + lL * cos(perTheta), x - lL * cos(perTheta)];
                    newY = [y + lL * sin(perTheta), y - lL * sin(perTheta)];
                    x2 = round(newX(2));
                    y2 = round(newY(2)); 
                    if x2 <= arr_bounds(2)-10 && y2 <= arr_bounds(1)-10 && x2 >0 && y2 >0
                        if mask(y2, x2) == 0 
                            len_2 = sqrt((x-x2)^2+(y-y2)^2);
                        else
                            flag=1;
                            plot([newX(1), newX(2)], [newY(1), newY(2)], 'g-');
                        end
                    else
                        flag=1;
                        plot([newX(1), newX(2)], [newY(1), newY(2)], 'g-');
                    end
                end

                len_of_membrane = len_1+len_2;
                if flag == 0
                %text(x,y+20, string(len_of_membrane));
                             
                    plot([newX(1), newX(2)], [newY(1), newY(2)], '-b');
            
                end
                break;

            end 
       end
        % 7. check if values are suitable (flag)
        if flag == 0
           widths_good = [widths_good len_of_membrane];
       else
           flag = 0;
       end

    end
    hold off

end

    widths = widths_good';

end