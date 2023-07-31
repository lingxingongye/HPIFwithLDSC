function d = Dx(u)
[rows,cols,p] = size(u); 
d = zeros(rows,cols,p);
d(:,2:cols,:) = u(:,2:cols,:)-u(:,1:cols-1,:);
d(:,1,:) = u(:,1,:)-u(:,cols,:);
return
