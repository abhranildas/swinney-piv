function [X_traj,Y_traj]=rk4_gi(Int,t,F_u,F_v,dt)

%preallocation for X traj calculation
X_traj=zeros(length(Int(:,1)),length(t)); 
X_traj(:,1)=Int(:,1); 
U1=zeros(length(Int(:,1)),length(t));


%preallocation for X traj calculation
Y_traj=zeros(length(Int(:,2)),length(t)); 
Y_traj(:,1)=Int(:,2); 
V1=zeros(length(Int(:,1)),length(t));

%a = waitbar(0,'Evaluating Trajectories...');
for i=1:length(t)-1
    
    
 %RK4 using griddedInterp   
    u1=F_u(X_traj(:,i),Y_traj(:,i),t(i)*ones(size(X_traj,1),1));
    v1=F_v(X_traj(:,i),Y_traj(:,i),t(i)*ones(size(X_traj,1),1));
    
    u2=F_u(X_traj(:,i)+.5*u1*dt,Y_traj(:,i)+.5*v1*dt,t(i)*ones(size(X_traj,1),1)+.5*dt);
    v2=F_v(X_traj(:,i)+.5*u1*dt,Y_traj(:,i)+.5*v1*dt,t(i)*ones(size(X_traj,1),1)+.5*dt);
    
    u3=F_u(X_traj(:,i)+.5*u2*dt,Y_traj(:,i)+.5*v2*dt,t(i)*ones(size(X_traj,1),1)+.5*dt);
    v3=F_v(X_traj(:,i)+.5*u2*dt,Y_traj(:,i)+.5*v2*dt,t(i)*ones(size(X_traj,1),1)+.5*dt);
    
    u4=F_u(X_traj(:,i)+u3*dt,Y_traj(:,i)+v3*dt,t(i)*ones(size(X_traj,1),1)+dt);
    v4=F_v(X_traj(:,i)+u3*dt,Y_traj(:,i)+v3*dt,t(i)*ones(size(X_traj,1),1)+dt);
    
    U1(:,i)=(1/6)*(u1+2*u2+2*u3+u4);
    V1(:,i)=(1/6)*(v1+2*v2+2*v3+v4);
    
    X_traj(:,i+1)=X_traj(:,i)+dt*U1(:,i);
    Y_traj(:,i+1)=Y_traj(:,i)+dt*V1(:,i);
    %waitbar(i/(length(t)-1))
end
%close(a)