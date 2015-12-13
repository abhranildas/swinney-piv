%% Convert .nc files to MATLAB data and calibrate length
% Section written by Abhranil to supply data to Dawson's code that follows.

%This script has to be run while the current directory
%contains the .nc files.

clc
%Set Parameters
basefilename='preprocessed_';
startfile=1;
endfile=1200;
%Calibration Parameters
%Horizontal and vertical length extents (set between 0 & 1 if unknown)
xmin=0; xmax=38.65;
ymin=47.64; ymax=68.17;
%Frames per second of the video
fps=12;

%Initialize space and time grids and output data structure
tData=(startfile-1:3:endfile-1)/12;
filename=[basefilename,num2str(startfile),'-',num2str(startfile+2),'.nc'];
X = double(ncread(filename,'Civ2_X'));
Y = double(ncread(filename,'Civ2_Y'));

rescaleX=(xmax-xmin)/range(X);
rescaleY=(ymax-ymin)/range(Y);
repositionX=xmin-min(X)*rescaleX;
repositionY=ymin-min(Y)*rescaleY;

X=X*rescaleX+repositionX;
Y=Y*rescaleY+repositionY;

%Create a uniform square grid with approx. as many points as original:
gridspacing=sqrt(((max(X)-min(X))*(max(Y)-min(Y)))/size(X,1));
[gridX,gridY]=ndgrid(min(X):gridspacing:max(X),min(Y):gridspacing:max(Y));

xData=gridX(:,1)';
yData=gridY(1,:);
%Calibrate frame length and position
% xData=xData*(xmax-xmin)/range(xData);
% xData=xData-min(xData)+xmin;
% 
% yData=yData*(ymax-ymin)/range(yData);
% yData=yData-min(yData)+ymin;


uData=zeros(size(xData,2),size(yData,2),size(tData,2));
vData=zeros(size(xData,2),size(yData,2),size(tData,2));

%Loop through .nc files, appending to output data structure
t=1;
fprintf('Reading .nc files %d to %d into MATLAB data:     ',[startfile,endfile-1]);
for i=startfile:3:endfile-1
    filename=[basefilename,num2str(i),'-',num2str(i+2),'.nc'];
    X = double(ncread(filename,'Civ2_X'));
    Y = double(ncread(filename,'Civ2_Y'));
    U = double(ncread(filename,'Civ2_U_smooth'));
    V = double(ncread(filename,'Civ2_V_smooth'));
    F = ncread(filename,'Civ2_F');
    FF = ncread(filename,'Civ2_FF');
    
    %Remove all warnings, errors and NaN points:
    err=(F~=0|FF==1|isnan(X)|isnan(Y)|isnan(U)|isnan(V));
    X(err)=[];
    Y(err)=[];
    U(err)=[];
    V(err)=[];
    
    X=X*rescaleX+repositionX;
    Y=Y*rescaleY+repositionY;
    
    U=U*rescaleX;
    V=V*rescaleY;
    
    %quiver(X,Y,U,V,'k');
    %figure();
    uData(:,:,t)=griddata(X,Y,U,gridX,gridY);
    vData(:,:,t)=griddata(X,Y,V,gridX,gridY);
    %quiver(gridX,gridY,gridU,gridV,'k')
    t=t+1;
    fprintf('\b\b\b\b\b%4d\n',i);
    %fprintf('\b\b\b\b');
end

%Invert video rotation
temp=xData;
xData=yData;
yData=temp;
temp=uData;
uData=permute(vData, [2 1 3]);
vData=permute(temp, [2 1 3]);

clear temp repositionX repositionY rescaleX rescaleY startfile endfile i t basefilename filename X Y U V F FF err xmin xmax ymin ymax gridX gridY gridspacing
%% Calculate trajectories
% Creating ndgrids   
    [Xgrid,Ygrid,tgrid]=ndgrid(xData,yData,tData); ugrid=uData; vgrid=vData;

%load Data_Set
%Evaluate Gridded Interpolant
    [F_u,F_v]=GI_data(Xgrid,Ygrid,tgrid,ugrid,vgrid);

%setting initial conditions
    %dx=10; %spacing b/t IC
    [IntX,IntY]=meshgrid(xData, yData); Int=[IntX(:) IntY(:)];
    %Int=[X_traj_in(:,length(t_traj)) Y_traj_in(:,length(t_traj))]; % use final pos as initial pos for next calc
    
% Calculating trajectories
    dt_traj=1; %time step of trajectories
    t_traj=tData;
    [X_traj,Y_traj]=rk4_gi(Int,t_traj,F_u,F_v,dt_traj);

 % Exclude trajectories that leave the domain
%     EX=zeros(size(X_traj,1),4); 
%     for i=1:size(X_traj,1)
%         Maxx=max(X_traj(i,:)); Maxy=max(Y_traj(i,:)); Minx=min(X_traj(i,:)); Miny=min(Y_traj(i,:));
%         EX(i,:)=[Maxx Minx Maxy Miny]; % Extremum values
%     end
%     Ind_rng=find(EX(:,1)<max(xData) & EX(:,2)>min(xData) & EX(:,3)<max(yData) & EX(:,4)>min(yData));
%     X_traj_in=X_traj(Ind_rng,:); Y_traj_in=Y_traj(Ind_rng,:); 

% Creating Trajectory Dataset    
    traj=zeros(length(X_traj(:,1)),2*length(t_traj)); 
    traj(:,1:2:end)=X_traj; traj(:,2:2:end)=Y_traj;
%tData=tData/fps;
%ave experimental_PIV_data.mat tData ugrid vgrid gridX gridY
clear Maxx Maxy Minx Miny F_u F_v Int IntX IntY tgrid i X_traj X_traj_in Y_traj Y_traj_in k t_traj dt_traj dx EX Ind_rng ugrid vgrid Xgrid Ygrid
