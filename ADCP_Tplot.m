close all
clear
Mset = 'BGR'
mooringnb = '17177_2019'
if strcmp(Mset,'GSR')
    load(['./DATA/GSR/MOR00' mooringnb '_merged_adcps_QA.mat'])
else
    load(['./DATA/BGR/ADCP' mooringnb '.mat'])
end


