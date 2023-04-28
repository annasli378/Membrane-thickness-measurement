clear all, close all,
%%
MASK  = load("CALE_OBRAZKI\Masks_filled\1_Mask.mat");
maska_membrana = MASK.BW2;
% figure, imshow(maska_membrana)

%%
props = regionprops(maska_membrana, 'Area');
sortedAreas = sort([props.Area], 'descend');
[labeledImage, numBlobs] = bwlabel(maska_membrana);
%%
figure, imshow(labeledImage)

%%
mask_atr = struct('mask', 0, 'skel', 0, 'edges',0);

for i = 1:numBlobs
    % PixelIdxList regionprops
    skiel = bwskel(labeledImage==i);
    edges = bwmorph(labeledImage==i,'remove');

    mask_atr(i).mask = labeledImage==i;
    mask_atr(i).skel = skiel;
    mask_atr(i).edges = edges;

%     figure,
%     subplot(2,1,1)
%     imshow(labeledImage==i)
%     subplot(2,1,2)
%     imshow(skiel+edges)
end

%%
pomiar = 50;
start = 10;

for i = 1:numBlobs
    skel_pix = regionprops(mask_atr(i).skel, "PixelList");
    skel_pix = skel_pix.PixelList;
    skel_len = length(skel_pix);
    stop = skel_len-1; 

    skel_edges = mask_atr(i).skel + mask_atr(i).edges;
    edges_pix = regionprops(mask_atr(i).edges, "PixelList");
    edges_pix = edges_pix.PixelList;
    
    mask = mask_atr(i).mask;

    x1 = skel_pix(1,1); y1 = skel_pix(1,2);
    xend = skel_pix(end,1); yend = skel_pix(end,2);


    figure,
    imshow(skel_edges)
    hold on

    S = start:pomiar:stop;

%     for s=start:pomiar:stop
%         X(s) = skel_pix(s,1); 
%         Y(s) = skel_pix(s,2);
%     end
% 
%     dy=diff(Y)./diff(X);
%     plot(X(2:end),dy, '--g')

    for s=start:pomiar:stop
        x = skel_pix(s,1); y = skel_pix(s,2);
        if s == start 
            x_l = skel_pix(1,1); y_l = skel_pix(1,2);
            x_p = skel_pix(s+pomiar,1); y_p = skel_pix(s+pomiar,2);
        elseif s + pomiar >= skel_len-1
            x_l = skel_pix(s-pomiar,1); y_l = skel_pix(s-pomiar,2);
            x_p = skel_pix(end,1); y_p = skel_pix(end,2);
        else 
            x_l = skel_pix(s-pomiar,1); y_l = skel_pix(s-pomiar,2);
            x_p = skel_pix(s+pomiar,1); y_p = skel_pix(s+pomiar,2);
        end

       x0 = (x_l+x_p)/2; y0 = (y_l+y_p)/2;

        plot(x,y, 'r*')
        


%         plot([x_l x_p], [y_l y_p], 'r-')
%         plot((x_l+x_p)/2, (y_l+y_p)/2, 'go')


%         [k,dist] = dsearchn(edges_pix, [x y]);
%         plot(edges_pix(k, 1), edges_pix(k,2), 'go')

        x_wekt = [x_l x x_p];
        y_wekt = [y_l y y_p];

        p = polyfit(x_wekt, y_wekt, 2);
        k = polyder(p);
        Y1 = polyval(p, x_wekt);

        plot(x_wekt, Y1, '--g')   


%         L = 50;
%         alpha = 90;
%         x2=x+(L*cos(alpha));
%         y2=y+(L*sin(alpha));
%         plot([x x2],[y y2], '--y')

%         if s - pomiar > start && s + pomiar < skel_len-1
%             y_1 = skel_pix(s+pomiar,2);
%             y__1 = skel_pix(s-pomiar,2);
%             x_1 = skel_pix(s+pomiar,1);
%             x__1 = skel_pix(s-pomiar,1);            
%             slope = (y_1-y__1) / (x_1 - x__1);
            
            %Y = slope * (x - x(n)) + y(n);
%             x_wekt = [x__1 x x_1];
%             y_wekt = [y__1 y y_1];
% 
%             p = polyfit(x_wekt, y_wekt, 2);
%             k = polyder(p);
%             Y1 = polyval(p, x_wekt);
% 
%             plot(x_wekt, Y1, '--g')
% 
% 
%             L = 50;
%             alpha = 90;
%             x2=x+(L*cos(alpha));
%             y2=y+(L*sin(alpha));
%             plot([x x2],[y y2], '--y')
            


%         end

    end
    hold off



end


