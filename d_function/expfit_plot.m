function [fitresult, gof] = expfit_plot(y, x)
%CREATEFIT(Y,X)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : y
%      Y Output: x
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 12-Jan-2021 19:11:33


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( y, x );

% Set up fittype and options.
ft = fittype( 'exp1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [269.795249655916 0.000198611620340816];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'x vs. y', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel y
ylabel x
grid on

