% ----------------- MATlab Code for Tumor extraction ----------------------
%% ------------------------------------------------------------------------
image_data=imread('D:\STUDIES\Projects\DSP Project\Brain Tumor\1.jpg');
figure,
    imshow(image_data); 
    title('Brain MRI Image');
    
%% ------------------------------------------------------------------------
image_data = imresize(image_data,[224,224]);
image_data= rgb2gray(image_data); % Gray Scaling

image_data = medfilt2(image_data); % Median Filter
image_data= im2bw(image_data,.6);

figure, 
    imshow(image_data);
    title('Thresholded Image');
    
%% ------------------------------------------------------------------------
hy = -fspecial('sobel');
hx = hy';
Iy = imfilter(double(image_data), hy, 'replicate');
Ix = imfilter(double(image_data), hx, 'replicate');

gradmag = sqrt(Ix.^2 + Iy.^2);
L = watershed(gradmag);
Lrgb = label2rgb(L);

figure,
    imshow(Lrgb); 
    title('Watershed segmented image');
    
%% -----------------------------------------------------------------
se = strel('disk', 20);  % se - Structuring Element
Io = imopen(image_data, se);
Ie = imerode(image_data, se);

Iobr = imreconstruct(Ie, image_data);
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

I2 = image_data;
fgm = imregionalmax(Iobrcbr);
I2(fgm) = 255;

se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 20);

I3 = imerode(image_data, se);
bw = im2bw(Iobrcbr);
figure
    imshow(bw);
    title('only tumor');
%% -----------------------------------------------------------------