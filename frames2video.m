%This script has to be run while the current directory
%is the one containing the frame images.

%1. SET PARAMETERS
basefilename='preprocessed_';
startfile=1;
endfile=1200;

%2. CREATE VIDEO OBJECT
outputVideo = VideoWriter('preprocessed_uniform_imadjust.avi');
outputVideo.FrameRate = 30;
open(outputVideo);

%3. WRITE FRAMES TO VIDEO AND CLOSE
for i = startfile:endfile
   writeVideo(outputVideo,imread([basefilename,num2str(i),'.png']));
end
close(outputVideo);

clear basefilename startfile endfile i outputVideo