%This script has to be run while the current directory is the one
%containing the image frames.
%It removes the average background from all the frames, then implements
%MATLAB's 'imadjust' on each frame using the brightness distribution over
%all the frames (it concatenates all the frames to get this distribution).

set(0,'DefaultFigureWindowStyle','docked');

%SET PARAMETERS
basefilename='test5a_';
startfile=1;
endfile=1201;


%LOAD ALL THE FRAMES INTO AN ARRAY
% Load first frame to get resolution:
init=imread([basefilename,num2str(startfile),'.png']); 
images=zeros([size(init), endfile-startfile+1],'uint8');
% Read in remaining frames:
for i=1:size(images,3)
  images(:,:,i)=imread([basefilename,num2str(i),'.png']);
end;

%GET AVERAGE BACKGROUND
meanImg = uint8(mean(images,3));

%INITIALIZE CONCATENATED IMAGE
concatImg=zeros(size(init,1)*(endfile-startfile+1),size(init,2),'uint8');

%REMOVE BACKGROUND, CREATE CONCATENATED IMAGE AND GET IMADJUST LIMITS
for i=1:size(images,3)
    images(:,:,i)=images(:,:,i)-meanImg;
    concatImg(1+size(init,1)*(i-1):size(init,1)*i,:)=images(:,:,i);    
end
limits=stretchlim(concatImg);
clear concatImg

%IMAGE ADJUST EACH FRAME WITH RESPECT TO LIMITS OF CONCATENATED IMAGE,
%WRITE THEM TO FILE
for i=1:size(images,3)
    images(:,:,i)=imadjust(images(:,:,i),limits);
    imwrite(images(:,:,i)-meanImg,['preprocessed/preprocessed_',num2str(i),'.png']);
end

clear basefilename startfile endfile i
