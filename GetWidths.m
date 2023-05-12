function widths = GetWidths(start,step, mask_atr, numBlobs, show_plots)
%GETWIDTHS Summary of this function goes here
%   Detailed explanation goes here

%   INPUTS:
% start 
% step
% mask_atr - struct with all attributes
% show_plots - show plots if true

%   OUTPUTS:
% widths 

szerokosci_dobre = [];


for i = 1:numBlobs
    skel_pix = regionprops(mask_atr(i).skel, "PixelList");
    skel_pix = skel_pix.PixelList;
    skel_len = length(skel_pix);
    stop = skel_len-1; 

    mask = mask_atr(i).mask;

    %skel_edges = mask_atr(i).skel + mask_atr(i).edges;
    %edges_pix = regionprops(mask_atr(i).edges, "PixelList");
    %edges_pix = edges_pix.PixelList;
    %x1 = skel_pix(1,1); y1 = skel_pix(1,2);
    %xend = skel_pix(end,1); yend = skel_pix(end,2);

    % Show plots
    if show_plots 
    figure,
    imshow(mask)
    hold on
    end

    
    flag = 0;

    for s=start:step:stop
        x = skel_pix(s,1); y = skel_pix(s,2);

        % sliding along the skeleton to determine the points before and after
        if s == start 
            x_l = skel_pix(1,1); y_l = skel_pix(1,2);
            x_p = skel_pix(s+step,1); y_p = skel_pix(s+step,2);
        elseif s + step >= skel_len-1
            x_l = skel_pix(s-step,1); y_l = skel_pix(s-step,2);
            x_p = skel_pix(end,1); y_p = skel_pix(end,2);   
        else 
            x_l = skel_pix(s-step,1); y_l = skel_pix(s-step,2);
            x_p = skel_pix(s+step,1); y_p = skel_pix(s+step,2);    
        end
       
        % finding the angle of inclination
       slope = (y_l - y_p)./(x_l - x_p);
       perSlope = -1/slope;
       perTheta = atan(perSlope);
        
       % mark a point on the skeleton
       if show_plots 
       plot(x,y, 'r*')
       end

       % distances from both edges 
       len_1 = 0;
       len_2 = 0;
       len_of_membrane=0;
       
       % searching for locations from the measurement point to the edge of the mask or image
       for L = 1:stop
            lineLength = L; 
       
            % new coordinates
            newX = [x + lineLength * cos(perTheta), x - lineLength * cos(perTheta)];
            newY = [y + lineLength * sin(perTheta), y - lineLength * sin(perTheta)];

            if show_plots 
            plot([newX(1), newX(2)], [newY(1), newY(2)], '-b');
            end
            
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
            if mask(y1, x1) == 0
                %cutPoint1 = [y1, x1];
                len_1 = sqrt((x-x1)^2+(y-y1)^2);
                if y1 >= arr_bounds(1) || x1 >= arr_bounds(1)
                    flag=1;
                end
            end
            % check 2 point
            if mask(y2, x2) == 0
                %cutPoint2 = [y2, x2];
                len_2 = sqrt((x-x2)^2+(y-y2)^2);
                if y2 >= arr_bounds(1) || x2 >= arr_bounds(1)
                    flag=1;
                end
            end
            % calculation of membrane width
            if len_1 ~= 0 || len_2 ~= 0 
                len_of_membrane = len_1+len_2;
                if show_plots
                text(x,y+20, string(len_of_membrane));
                end
                break;

            end 
       end
  
        % checking for image edges when searching for mask edges and rejecting such lengths
        if flag == 0
           szerokosci_dobre = [szerokosci_dobre len_of_membrane];
       else
           flag = 0;
       end

    end
    hold off

end

    widths = szerokosci_dobre';

end











