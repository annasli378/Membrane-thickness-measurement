clc; close all; clear all
%% Wczytanie obrazów


    A = load(strcat('Masks/1_A_Mask.mat'));
    B = load(strcat('Masks/1_B_Mask.mat'));
    C = load(strcat('Masks/1_C_Mask.mat'));
    D = load(strcat('Masks/1_D_Mask.mat'));
    
    AB = [ A.ATmask B.ATmask(:,100:end,:)];
    CD = [ C.ATmask D.ATmask(:,100:end,:)];

    ABCD = [ AB ; CD(100:end,:,:)];


    %%

for i = 1:20

A = imread(strcat('Images/', num2str(i) , '_A.png'));
B = imread(strcat('Images/', num2str(i) , '_B.png'));
C = imread(strcat('Images/', num2str(i) , '_C.png'));
D = imread(strcat('Images/', num2str(i) , '_D.png'));
%
Polaczenie_obrazkow_z_4(A,B,C,D, strcat('CALE_OBRAZKI\Images\', num2str(i), '_.png'));
end


%%

for i = 1:20
    
    A = load(strcat('Masks/', num2str(i) , '_A_Mask.mat'));
    B = load(strcat('Masks/', num2str(i) , '_B_Mask.mat'));
    C = load(strcat('Masks/', num2str(i) , '_C_Mask.mat'));
    D = load(strcat('Masks/', num2str(i) , '_D_Mask.mat'));
    
    AB = [ A.ATmask(:,1:end-50,:) B.ATmask(:,50:end,:)];
    CD = [ C.ATmask(:,1:end-50,:) D.ATmask(:,50:end,:)];

    ABCD = [ AB(1:end-50,:,:) ; CD(50:end,:,:)];


    path = strcat(num2str(i), '_Mask.mat')
    save(path, "ABCD")

end
%%
% 
% %%
% figure,
% subplot(2,2,1)
% imshow(A)
% subplot(2,2,2)
% imshow(B)
% subplot(2,2,3)
% imshow(C)
% subplot(2,2,4)
% imshow(D)
% %% połączyć 
% AB = [ A B(:,100:end,:)];
% CD = [ C D(:,100:end,:)];
% %%
% ABCD = [ AB ; CD(100:end,:,:)];

imwrite(ABCD, 'CALE_OBRAZKI\OVERLAY\1_Ann.tiff')