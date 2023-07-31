
function d = Dyt(u)
[rows,cols,p] = size(u); 
d = zeros(rows,cols,p);
d(1:rows-1,:,:) = u(1:rows-1,:,:)-u(2:rows,:,:);
d(rows,:,:) = u(rows,:,:)-u(1,:,:);
return