% clear
% close all

TeleDynADCP

for vlim = 0:0.02:0.2
        
    v_star = v
    v_star(v<vlim) = nan;
    v_star(~isnan(v_star))=1;
    v_mag = v_star.*thetha;

    group = (1:nb_of_sensors) .* ones(mes,nb_of_sensors);
    measure = [v_mag];
    figure('units', 'normalized', 'outerposition', [0 0 1 0.5])
    boxplot(measure(:),group(:))
    title(['ignoring currents of magnitude below' num2str(vlim) 'm.s-1'])

end