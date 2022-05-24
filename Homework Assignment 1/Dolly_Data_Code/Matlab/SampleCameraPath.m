% Sample use of PointCloud2Image(...)
% 
% The following variables are contained in the provided data file:
%       BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size
% None of these variables needs to be modified


clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load data.mat

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
R       = eye(3);
fmove    = [0 0 -0.25]';


z = ForegroundPointCloudRGB(3, 1);
st = [0,0,0];
dz= 0.5;


% Creating video file
v = VideoWriter('newfile.wmv');
% Setting Video frame rate to 15Hz
v.FrameRate = 15;
open(v)


for step=0:15
    tic
    fname       = sprintf('SampleOutput%03d.jpg',step);
    fprintf('\nGenerating %s\n',fname);
    ft           = step * fmove;
    
    scale = (z + step*dz) / z;
    st = [0;0;step*dz];
    
    new_K = K * [scale, 0, 0; 0, scale, 0; 0, 0, 1];
    M = new_K * [R, st];
    
    im          = PointCloud2Image(M,data3DC,crop_region,filter_size);
    imwrite(im,fname);
   

    
    
    toc    
end

for itr = 0:8
    tic
    img = imread(sprintf('SampleOutput%03d.jpg',itr));
    writeVideo(v,img);
    
    toc
end

close(v)
