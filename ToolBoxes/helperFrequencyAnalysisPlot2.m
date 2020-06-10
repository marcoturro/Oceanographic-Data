function helperFrequencyAnalysisPlot2(x1,x2,x3,y1,y2,y3,xlbl,ylbl,lgnd,xlim)
% Plot helper function for the FrequencyAnalysisExample

% Copyright 2012 The MathWorks, Inc.

plot(1./x1./3600,y1,'-^')
hold on
plot(1./x2./3600,y2,'-s')
try
plot(1./x3./3600,y3,'-d')
end
xlabel(xlbl)
ylabel(ylbl)
set(gca,'FontSize',14)

if nargin > 5 && ~isempty(lgnd)
  legend(lgnd{:},'Location','southeast')
end
grid on
if nargin > 6 && ~isempty(xlim) 
  ax = axis;
  % axis([xlim(1) xlim(2) ax(3:4)])
else
  axis tight
end
