function [F_u,F_v]=GI_data(Xgrid,Ygrid,tgrid,ugrid,vgrid)
F_u=griddedInterpolant(Xgrid,Ygrid,tgrid,ugrid);
F_v=griddedInterpolant(Xgrid,Ygrid,tgrid,vgrid);