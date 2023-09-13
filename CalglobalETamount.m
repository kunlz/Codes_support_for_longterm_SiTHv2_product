function [TET,MET,reallandarea,area,X] = CalglobalETamount(ETraster,k,landfraction)
% function input --------------------
% ETraster : The input ET matrix, mm
% k        : Spatial Resolution, e.g. 0.25
% function output -------------------
% TET      : Total Amount of ET, km^3
% MET      : Total Mean of ET,   mm

% Calculate the real area for each grid, km^2
area = CalrealArea(k);
% area(isnan(ETraster)) = 0;
area = landfraction.*area;


% reallandarea = sum(area(:),'omitnan');

ETraster(isnan(ETraster)) = 0; 
% Calculate the real volume for each grid, km^3
X = area.*ETraster./1e6;

% Amount ET, km^3
TET = sum(X(:),'omitnan');

% Mean ET, mm
% area(X==0) = 0; 
reallandarea = sum(area(:),'omitnan');
MET = 1e6.*TET./reallandarea;

end

function [area] = CalrealArea(k)

earthellipsoid = referenceSphere('earth','km');

x1 = -90+k/2;
x2 = 90-k/2;
y1 = -180+k/2;
y2 = 180-k/2;

lat =  x1 : k : x2;
long =  y1 : k : y2;
LT11 = flipud(repmat(lat',1,360./k));
LG11 = repmat(long,180./k,1);
LT_up = LT11+k/2;
LT_dw = LT11-k/2;
LG_le = LG11-k/2;
LG_ri = LG11+k/2;
area = areaquad(LT_dw,LG_le,LT_up,LG_ri,earthellipsoid);

end