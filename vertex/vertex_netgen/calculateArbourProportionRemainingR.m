function [p] = calculateArbourProportionRemainingR( ...
  somaPosition, R, axonArborRadius, kernel)

if strcmpi(kernel, 'gaussian') || strcmpi(kernel, 'g')
  lx1 = -somaPosition(:, 1);
  lx2 = R*2 - somaPosition(:, 1);
  ly1 = -somaPosition(:, 2);
  ly2 = R*2 - somaPosition(:, 2);
  p = ( ...
    (erf(bsxfun(@rdivide, lx1, (sqrt(2) .* axonArborRadius))) - ...
    erf(bsxfun(@rdivide, lx2, (sqrt(2) .* axonArborRadius)))) .* ...
    (erf(bsxfun(@rdivide, ly1, (sqrt(2) .* axonArborRadius))) - ...
    erf(bsxfun(@rdivide, ly2, (sqrt(2) .* axonArborRadius)))) ) ./ 4;
elseif strcmpi(kernel, 'uniform') || strcmpi(kernel, 'u')
  numPoints = (pi*R^2)/20; % use Monte Carlo sampling to approximate overlap
  t = 2*pi*rand(1,numPoints);
  r = axonArborRadius*sqrt(rand(1,numPoints));
  x = bsxfun(@plus, somaPosition(:, 1), r.*cos(t));
  y = bsxfun(@plus, somaPosition(:, 2), r.*sin(t));
  xin = x <= R*2 & x >= 0;
  yin = y <= R*2 & y >= 0;
  p = sum(xin & yin, 2) ./ numPoints;
elseif strcmpi(kernel, 'exponential') || strcmpi(kernel, 'e')
  p = 1; % TO DO
else
  p = 1; % TO DO
end