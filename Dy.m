function d = Dy(u)
[rows,cols,p] = size(u); 
d = zeros(rows,cols,p);
d(2:rows,:,:) = u(2:rows,:,:)-u(1:rows-1,:,:);
d(1,:,:) = u(1,:,:)-u(rows,:,:);
return
