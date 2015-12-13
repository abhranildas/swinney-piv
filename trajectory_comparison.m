startfile=1;
endfile=1200;

writerObj = VideoWriter('10_3_2b_trajectory_comparison.avi','Uncompressed AVI');
writerObj.FrameRate=25;
open(writerObj);
xbounds=[min(traj(:,1)),max(traj(:,1))];
ybounds=[min(traj(:,2)),max(traj(:,2))];
figure('Position', [100, 0, 1000, 544]);
set(gca,'LooseInset',get(gca,'TightInset'));
set(gcf, 'visible', 'off');
fprintf('Writing frames %d to %d to video:     ',[startfile,endfile]);
for i=startfile:endfile
    image(ybounds,xbounds,flipud(imread(['preprocessed/preprocessed_',num2str(i),'.png'])));
    colormap(gray);
    hold on;
    set(gca,'YDir','normal');
    plot(traj(:,2*i),traj(:,2*i-1),'.','MarkerSize',3,'MarkerEdgeColor','red','MarkerFaceColor','red');
    hold off;
    axis equal tight;
    xlim(ybounds);
    ylim(xbounds);
    xlabel('cm');
    ylabel('cm');
    frame = getframe(gcf); 
    writeVideo(writerObj,frame);
    fprintf('\b\b\b\b\b%4d\n',i);
end
close(writerObj);

clear xbounds ybounds i
