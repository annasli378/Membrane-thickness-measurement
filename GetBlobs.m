function [struct_mask_art, blobs] = GetBlobs(maska_membrana)
%GETBLOBS Summary of this function goes here
%   Detailed explanation goes here
% input - binary mask
% output - stuct with all attributes needed, number of elements on the
% image

% 1. Get labels of each element
[labeledImage, numBlobs] = bwlabel(maska_membrana);
[rows, kols] = size(maska_membrana);

mask_atr = struct('mask', 0, 'skel', 0, 'edges',0);
cnt = 1;
for i = 1:numBlobs
    % 2. PixelIdxList regionprops
    skiel = bwskel(labeledImage==i,'MinBranchLength',200);
    edges = bwmorph(labeledImage==i,'remove');

    % 2. checking that the fragment is not going out on the borders of the image
    pix_list_edges = regionprops(edges, "PixelList");
    pix_list_edges = pix_list_edges.PixelList;
    len_edges = length(pix_list_edges);

    len_tx = 0; len_bx = 0;len_ry = 0; len_ly = 0;
    for e = 1:len_edges
        pixe = pix_list_edges(e,:);
        if pixe(1) == 0
            len_ly = len_ly +1;
        elseif pixe(1) == kols
            len_ry=len_ry+1;
        end

        if pixe(2) == 0
            len_tx = len_tx+1;
        elseif pixe(2) == rows
            len_bx = len_bx +1;
        end

    end

    if len_tx > len_edges/4 || len_bx > len_edges/4 || len_ly > len_edges/4 || len_ry > len_edges/4
        disp("object is too adjacent to the edge")
    else

        % 3. save properities
        if sum(sum(skiel)) > 0
            mask_atr(cnt).mask = labeledImage==i;
            mask_atr(cnt).skel = skiel;
            mask_atr(cnt).edges = edges;
            % figure, imshow(mask)
            % figure, imshow(skiel);
            cnt = cnt + 1;
        end
    end
end
% 4. Return results
struct_mask_art = mask_atr;
blobs = cnt-1;

end

