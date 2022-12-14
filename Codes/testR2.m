% Author: Santosh Chapaneri

function R2 = testR2(X, Y)

d = (X - Y).^2;
d = sum(d,1);

nd = (Y - repmat(mean(Y), length(X), 1)).^2;
nd = sum(nd,1);

R2 = 1 - (d/nd);


