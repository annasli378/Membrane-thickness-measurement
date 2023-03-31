clear all, close all,
%%
close all,
MASK  = load("CALE_OBRAZKI\Masks\11_Mask.mat");
mask = MASK.ABCD;
maska_membrana = mask==1;
%figure,
%imshow(maska_membrana)
% Zalanie dziur

BW = imfill(maska_membrana, "holes");
%figure,
%imshow(BW)
% wygładzenie brzegów
BC = imclose(BW, strel('disk',9)); 
BO = imopen(BC, strel('disk',7)); 
BW2 = imfill(BO, "holes");


figure,
imshow(BW2)
%

% Szkieletyzacja
B = bwskel(BW2, 'MinBranchLength', 60);
figure,
imshow(B)
%
save("CALE_OBRAZKI\SKEL\11_Mask_Skel.mat", "BW")
% Obrzeża
%BW2 = bwmorph(maska_membrana,'remove');

%
% figure, 
% subplot(1,3,1)
% imshow(bwskel(maska_membrana))
% subplot(1,3,2)
% imshow(bwskel(BW))
% subplot(1,3,3)
% imshow(bwskel(BO))

%% dla wszystkich obrazów
for i = 1:20
    
    m = load(strcat('CALE_OBRAZKI/Masks/', num2str(i) , '_Mask.mat'));
    mask = m.ABCD.ATmask;
    mask_m = mask==1;
    
    % zalanie otworów
    BW = imfill(mask_m, "holes");
    % wygładzenie
    BO = imopen(BW, se); 
    % wyświetlenie:
    figure, 
    subplot(1,2,1)
    imshow(BW)
    subplot(1,2,2)
    imshow(BO)


    % zapis obu
    path1 = strcat('CALE_OBRAZKI/Masks_filled/', num2str(i), '_Mask.mat')
    path2 = strcat('CALE_OBRAZKI/Masks_filled_smoothed/', num2str(i), '_Mask.mat')

    save(path1,"BW")
    save( path2,"BO")
end