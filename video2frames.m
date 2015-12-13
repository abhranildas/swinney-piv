video=VideoReader('test5a.avi');
i=1;
while hasFrame(video)
    imwrite(readFrame(video),sprintf('test5a_%d.png', i),'png');
    i=i+1;
end
clear i
%whos frames