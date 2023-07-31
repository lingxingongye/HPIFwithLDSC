function X = my(M, P, ratio, sensor)
[~, ~, Mdim] = size(M);
[Mp, Np, ~] = size(P);
 switch sensor
    case 'QB'        
        alpha = [0.34 0.32 0.30 0.22]; % Band Order: B,G,R,NIR       
    case 'IKONOS'
        alpha = [0.26,0.28,0.29,0.28]; % Band Order: B,G,R,NIR
    case 'GeoEye1'         
        alpha = [0.23,0.23,0.23,0.23]; % Band Order: B,G,R,NIR       
    case 'WV2'       
        alpha = [0.35 .* ones(1,7), 0.27];      
  end

%parameter assignment%
mu = 0.005;
rou1 = 2;
rou2 = 0.1;
lambda = 0.01;
%parameter assignment%

%operator definition%
I = zeros(3,3);
I(2,2) = 1;
GtG = [0 -1 0;-1 4 -1;0 -1 0];
GtG2 = zeros(3,3,3);
GtG2(:,:,2) = GtG;
%operator definition%

%initialization%

X = imresize(M,ratio,'bicubic');
coe1 = X;
C = X;
B = X;
Bx = Dx(X);
By = Dy(X); 
Mlow = X;
Pdown = imresize(P, 1/ratio, 'bicubic');
Plow = imresize(Pdown, ratio, 'bicubic');
H = ones(size(X));
lambda1x = ones(size(X));
lambda1y = ones(size(X));
[row, col,~]=size(X);
temp=zeros(row,col);
temp(3:4:end,3:4:end)=1;
DtD = spdiags (temp(:),0,row*col, row*col);

itt = 100;
tt1 = psf2otf(GtG2, size(X));
tt2 = psf2otf(GtG, size(P));
block_size =7;


%% iteration
for i = 1:itt
    X_last = X;
    %% iteration of X%
    t1 = H + rou1*C + Dxt(lambda1x) + Dyt(lambda1y) + rou2*(Dxt(Bx) + Dyt(By));
    t2 = rou1*(1+rou2*tt1);
    X = real(ifftn(fftn(t1)./t2));
    X = max(0,X);
    X = min(1,X);

 %% iteration of C%
    for j =1: Mdim
        
         [quality, quality_map] = img_qi(coe1(:,:,j), Plow, block_size);
         coe = quality_map;
         t3 = Mlow(:,:,j) + coe.*(P-Plow) + lambda*(Mlow(:,:,j)./(P.*Plow)) - H(:,:,j) +rou1*X(:,:,j);
         t4 = 1 + rou1*1 +lambda./(P.^2);
         C(:,:,j) = real(t3./t4);
    end
    C = max(0, C);
    C = min(1, C);

 %% iteration of B%         
    t5 = Dx(X) - 1/rou2*lambda1x;
    t6 = Dy(X) - 1/rou2*lambda1y;
    Bx =sign(t5).*max(abs(t5) - mu/rou2, 0);
    By =sign(t6).*max(abs(t6) - mu/rou2, 0);
    


%% iteration of H and lambda1%
    H = H + rou1*(C - X);
    lambda1x = lambda1x + rou2*(Bx - Dx(X));
    lambda1y = lambda1y + rou2*(By - Dy(X));
    
    err(i) = norm(X_last(:) - X(:)) / norm(X_last(:));
    if  err(i)<1e-4
        break;
    end
end

end 



