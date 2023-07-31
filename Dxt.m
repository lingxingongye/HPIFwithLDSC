
function d = Dxt(u)
[rows,cols,p] = size(u); 
d = zeros(rows,cols,p);
d(:,1:cols-1,:) = u(:,1:cols-1,:)-u(:,2:cols,:);
d(:,cols,:) = u(:,cols,:)-u(:,1,:);
return