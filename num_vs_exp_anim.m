time=100;
figure(2);
for time=1:size(tData_num,2)
    subplot(2,2,1);
    imagesc(uData_num(:,:,time));
    colorbar;
    title('Num Horiz');
    subplot(2,2,2);
    imagesc(uData_exp(:,:,round(time*1050/321)));
    colorbar;
    title('Exp Horiz');
    subplot(2,2,3);
    imagesc(vData_num(:,:,time));
    colorbar;
    title('Num Vert');
    subplot(2,2,4);
    imagesc(vData_exp(:,:,round(time*1050/321)));
    colorbar;
    title('Exp Vert');
    pause(.01);
end