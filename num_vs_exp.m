set(0,'DefaultFigureWindowStyle','docked');

%% Velocity profile comparison at a vertical slice
figure(1);
subplot(2,1,1);
pc=pcolor(tData_num,yData_num,permute(vData_num(40,:,:),[2 3 1]));
set(pc, 'Linestyle', 'none');
xlabel('Time (s)');
ylabel('y (cm)');
title('Numerical Simulation');
c=colorbar;
%set(c,'YTick',[-1 0 .8]);
c.Label.String = 'Vertical velocity (cm/s)';
subplot(2,1,2);
pc=pcolor(tData_exp,yData_exp,permute(vData_exp(54,:,:),[2 3 1]));
set(pc, 'Linestyle', 'none');
xlabel('Time (s)');
ylabel('y (cm)');
title('Experimental PIV');
c=colorbar;
%set(c,'YTick',[-.6 0 .6]);
c.Label.String = 'Vertical velocity (cm/s)';

figure(2);
subplot(2,1,1);
pc=pcolor(tData_num,yData_num,permute(uData_num(40,:,:),[2 3 1]));
set(pc, 'Linestyle', 'none');
xlabel('Time (s)');
ylabel('y (cm)');
title('Numerical Simulation');
c=colorbar;
%set(c,'YTick',[-1.1 0 1]);
c.Label.String = 'Horizontal velocity (cm/s)';
subplot(2,1,2);
pc=pcolor(tData_exp,yData_exp,permute(uData_exp(54,:,:),[2 3 1]));
set(pc, 'Linestyle', 'none');
xlabel('Time (s)');
ylabel('y (cm)');
title('Experimental PIV');
c=colorbar;
%set(c,'YTick',[-.6 0 .6]);
c.Label.String = 'Horizontal velocity (cm/s)';
clear pc c
%quiver(gridX,gridY,ugrid(:,:,260),vgrid(:,:,260),'blue');
%% Velocity evolution comparison at a point
figure(3);
plot(tData_exp,permute(vData_exp(54,103,:),[2 3 1]));
hold on
plot(tData_num,permute(vData_num(40,80,:),[2 3 1]));
hold off
xlabel('Time (s)');
ylabel('Vertical velocity (cm/s)');
legend('Experimental','Numerical');
title('Velocity comparison at a point');
