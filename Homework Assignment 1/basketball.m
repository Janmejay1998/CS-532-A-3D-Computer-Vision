

img = imread('basketball-court.ppm');
imshow(img);

newimg = zeros(940, 500, 3, 'uint8');

a11 = [1 1];
a12 = [500 1];
a13 = [1 940];
a14 = [500 940];

b21 = [245 46];
b22 = [417 73];
b23 = [10 204];
b24 = [288 317];
x = [a11; a12; a13; a14];
xC = [b21; b22; b23; b24];

a = zeros(8,9);
for i=1:4
    a(2*i-1, 1:9) = [0 0 0 -x(i,1) -x(i,2) -1 xC(i,2)*x(i,1) xC(i,2)*x(i,2) xC(i,2)];
    a(2*i, 1:9) = [x(i,1) x(i,2) 1 0 0 0 -xC(i, 1)*x(i, 1) -xC(i, 1)*x(i,2) -xC(i,1)];
end
a(9, 9) = 1;

j = zeros(9,1);
j(9,1) = 1;
h = a\j;
h = reshape(h, 3, 3)';

for i=1:940
    for j = 1:500
        temp = [(h(1,1)*j + h(1,2)*i + h(1, 3))/(h(3,1)*j + h(3, 2)*i +h(3,3)) (h(2, 1)*j +h(2, 2)*i + h(2,3))/(h(3,1)*j + h(3,2)*i + h(3,3))];
        a = temp(1) - floor(temp(1));
        b = temp(2) - floor(temp(2));
        fla = floor(temp(1));
        flb = floor(temp(2));
        newimg(i,j,:) = img(flb,fla,:)*(1-a)*(1-b)+img(flb,fla+1,:)*(a)*(1-b)+img(flb+1,fla,:)*b*(1-a)+img(flb+1,fla+1,:)*a*b;
    end
end

      
imshow(newimg,'InitialMagnification',500,'Interpolation','bilinear');
imwrite(newimg, 'basketball_new_image.jpg');

