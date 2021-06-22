clc
clear all
close all
warning off
[filename,pathname]=uigetfile('*.*','Pick a MATLAB code file');
filename=strcat(pathname,filename);
a=imread(filename);
%subplot(3,4,1),
imshow(a);
%Convert to grayscale image
%b=rgb2gray(a);
b=im2gray(a);
%subplot(3,4,2),
imshow(b);
impixelinfo;

c=imbinarize(b,20/255);
%c=b>50;
%subplot(3,4,3),
imshow(c);

%Fill the holes in the image
d=imfill(c,'holes');
%subplot(3,4,4),
imshow(d);

%delete writings
e=bwareaopen(d,1000);
%subplot(3,4,5),
imshow(e);

PreprocessedImage=uint8(double(a).*repmat(e,[1 1 3]));
%subplot(3,4,6),
imshow(PreprocessedImage);

%contrast enhancememt
%to make bright pixels brighter 
PreprocessedImage1=imadjust(PreprocessedImage,[0.3
     0.7],[])+50;
 %0.2 0.8
%subplot(3,4,7),
imshow(PreprocessedImage1);

%Convert rgb image to grayscale

uo=rgb2gray(PreprocessedImage1);
%subplot(3,4,8),
imshow(uo);

mo=medfilt2(uo,[5 5]);
%subplot(3,4,9),
imshow(mo);

po=imbinarize(mo,250/255);
%po=mo>250;
%subplot(3,4,10),
imshow(po);

[r c m]=size(po);
%split window into grid
x1=r/2;
y1=c/3;
row=[x1 x1+200 x1+200 x1];
col=[y1 y1 y1+40 y1+40];
BW=roipoly(po,row,col);
%subplot(3,4,11),
imshow(BW);

k=po.*double(BW);
%subplot(3,4,12),
imshow(k);

figure;
figure.Position= [100 100 1040 1400];

montage({a,b,c,d,e,PreprocessedImage,PreprocessedImage1,uo,mo,po,BW,k},'BorderSize',[7 7], 'BackgroundColor','white')
montage.Position=[100 100 140 400];
M=bwareaopen(k,4);
[ya number]=bwlabel(M);
if(number>=1)
    disp('Stone is Detected');
    msgbox('Stone is detected','Result');
    text(200,1000,'Stone is detected','FontSize', 22);
else
    disp('No Stone is detected');
    msgbox('No Stone is detected','Result');
    text(200,1000,'No Stone is detected','FontSize', 22);
end