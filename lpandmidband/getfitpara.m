function [minper,maxper,pert,dev,normper] = getfitpara(sensor)
    %This function gets the fit parameters for the various instruments used
    %minper is the minimum period used for fitting
    %maxper is the maximum period used for fitting
    %pert is the maximum variable perturbation allowed in the coarse solver
    %dev is the deviation allowed in the coarse solver
    %normper is the normalization period used
    if(strcmp(sensor,'STS-1'))
        minper=40;
        maxper=1000;
        pert=2;
        dev=.001;
        normper=41;
    elseif(strcmp(sensor,'STS-1t5'))
        minper=40;
        maxper=900;
        pert=1.2;
        dev=.01;
        normper=41;
    elseif(strcmp(sensor,'KS-54000'))
        minper=40;
        maxper=1000;
        pert=2;
        dev=.01;
        normper=41;
    elseif(strcmp(sensor,'STS-2'))
        minper=40;
        maxper=800;
        pert=.1;
        dev=.0005;
        normper=41;
    elseif(strcmp(sensor,'CMG-3T'))
        minper=40;
        maxper=500;
        pert=.1;
        dev=.001;
        normper=41;
    elseif(strcmp(sensor,'TR-240'))
        minper=40;
        maxper=500;
        pert=.1;
        dev=.001;
        normper=41;
    end
end

