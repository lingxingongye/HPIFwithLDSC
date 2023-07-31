clear all;

sensor = 'QB'; 
    
lrms = load('image\lrms.mat');
lrms = lrms.cur;
lrms = mat2gray(lrms);
PAN = load('image\pan.mat');
pan = PAN.cur;
P = mat2gray(pan);
ratio = size(P,1)/size(lrms,1);
M = lrms;
X = model(M, P, ratio, sensor);


X_RGB = cat(3, X(:,:,3), X(:,:,2), X(:,:,1));
lrms_RGB = cat(3, lrms(:,:,3), lrms(:,:,2), lrms(:,:,1));
figure,imshow(X_RGB);
hold on
figure,imshow(lrms_RGB);
hold on
figure,imshow(P);

a = 1;

