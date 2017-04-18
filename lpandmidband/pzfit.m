function [bestfit,nom,amperror,phaserror,perrors,phasernom,ampernom]=pzfit(network,station,channel,location,year,day,sensor,samplerate,output,input)
%This function solves for the vector of bestfit instrument parameters.  It
%also returns the various errors that come with the calibration.
%INPUT: network code "IU", station code "ANMO", channel code "BHZ", location code "00", year "2010", day
%of the year number "123", sensor type "STS-2", and sample rate "40".
%OUTPUT: bestfit vector of pole values, nominal pole values, amplitude
%error from calibration with bestfit, phase error from calibration with
%bestfit, pole error values, phase error with nominal, amplitude error with
%nominal.


bestfit=[];

%Here we get the instrument parameters for the various types of instruments
[minper,maxper,pert,dev,normper]=getfitpara(sensor);

%Here we get the data and compute the sepectra
[cropow,inputpow,outputpow,fre]=getspectra(network,station,location,channel,year,day,samplerate,minper,maxper,output,input);

%Lets limit the frequency band of interest
omega=2*pi*fre;
indexhi=min(find(fre>1/minper));
indexlow=max(find(fre<1/maxper));

%The transfer function of the calibration
tcal=(omega).*cropow./inputpow;
tcal=tcal(indexlow:indexhi);

%Time to clip all of our frequency bands
fre=fre(indexlow:indexhi);
cropow=cropow(indexlow:indexhi);
inputpow=inputpow(indexlow:indexhi);
outputpow=outputpow(indexlow:indexhi);
omega=omega(indexlow:indexhi);


%Lets also normalize our calibration
norm=min(find(fre>1/normper));

tcal=tcal/tcal(norm);


omega=2*pi*fre;


%Time to get the phase response
calphaseresp=angle(tcal)*180/pi;

%Lets get the amplitude response since we will fit that
calampresp=(omega.^2).*outputpow./inputpow;


%Here we get the response model to be used for our sensor type.
[respmodel,nom]=getrespmodel(sensor,fre,norm);
 
 
%Lets make some functions that describe the model of the instrument.  First the amplitude 
tamp=@(p) respmodel(p).*conj(respmodel(p));

%Lets get the phase response model
tphase=@(p) angle(respmodel(p))*180/pi;

%The amplitude residual from the calibration and the model
resamp=@(p) 10*log10(tamp(p))-10*log10(tcal.*conj(tcal));

%The phase residual from the calibration and the model
resphase=@(p) tphase(p)-angle(tcal)*180/pi;

%The total normalized residual used for fitting
resid=@(p) [resamp(p)./max(abs(tamp(nom))); resphase(p)./max(abs(tphase(nom)))];

%Here is an initial solution by way of grid searching
prior=priorsol(resid,nom,pert,dev);
 
 
%Lets integrate our error using the fact that we have log spaced frequency
%points
residfit=@(p) sum(resid(p).*resid(p).*[0; diff(fre); 0; diff(fre)]);


%Lets solve the non-linear inverse problem again using the
%Levenberg-Marquardt method, we have already estimated a coarse global
%minima, from our grid search
[bestfit,b,c]=LMFsolve(residfit,prior,'Display',0,'MaxIter',2000);
 

%Now we can estimate the various errors from the calibration with our best
%fit and nominal pole values.
phaserror=sqrt(sum(resphase(bestfit).*resphase(bestfit).*[0; diff(fre)])); 
amperror=sqrt(sum(resamp(bestfit).*resamp(bestfit).*[0; diff(fre)])); 
phasernom=sqrt(sum(resphase(nom).*resphase(nom).*[0; diff(fre)])); 
ampernom=sqrt(sum(resamp(nom).*resamp(nom).*[0; diff(fre)])); 


%Lets get the pole errors (99%) confidence interval estimates
perrors=polerr(bestfit,tcal,fre,sensor,norm,respmodel);



%Lets make some pictures of our results.
fig1=figure(1);
clf
subplot(2,1,1)
%Lets plot the various amplitude responses
h1line=semilogx(1./fre,10*log10(tamp(nom)),'LineWidth',3,'Color','k');
hold on
h2line=semilogx(1./fre,10*log10(tcal.*conj(tcal)),'LineWidth',3,'Color','b');
h3line=semilogx(1./fre,10*log10(tamp(bestfit)),'LineWidth',3,'Color','r');


xlabel('Period (seconds)','FontSize',14);
ylabel('Vel. Resp (m/s)','FontSize',14);
set(gca,'FontSize',14);
title(['Cal Amplitude Response ' location ' ' station ' ' channel ' ' day ' ' year]);
xlim([minper maxper]);
h1Group = hggroup;
h2Group = hggroup;
h3Group =hggroup;

set(h1line,'Parent',h1Group);
set(h2line,'Parent',h2Group);
set(h3line,'Parent',h3Group);

set(get(get(h1Group,'Annotation'),'LegendInformation'),...
     'IconDisplayStyle','on');
 set(get(get(h2Group,'Annotation'),'LegendInformation'),...
     'IconDisplayStyle','on');
 set(get(get(h3Group,'Annotation'),'LegendInformation'),...
     'IconDisplayStyle','on');

legend('Scaled Nominal','Calibration','Best-Fit','Location','SouthWest');
subplot(2,1,2)
%Lets plot the phase response
h1line=semilogx(1./fre,tphase(nom),'LineWidth',3,'Color','k');
hold on
h2line=semilogx(1./fre,calphaseresp,'LineWidth',3,'Color','b');
h3line=semilogx(1./fre,tphase(bestfit),'LineWidth',3,'Color','r');

xlabel('Period (seconds)','FontSize',14);
ylabel('Phase Resp (degrees)','FontSize',14);
set(gca,'FontSize',14);
title(['Phase Response ' location ' ' station ' ' channel ' ' day ' ' year]);
xlim([minper maxper]);
h1Group = hggroup;
h2Group = hggroup;
h3Group=hggroup;

set(h1line,'Parent',h1Group);
set(h2line,'Parent',h2Group);
set(h3line,'Parent',h3Group);

set(get(get(h1Group,'Annotation'),'LegendInformation'),...
           'IconDisplayStyle','on');
set(get(get(h2Group,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','on');
set(get(get(h3Group,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','on');
 
legend('Scaled Nominal','Calibration','Best-Fit','Location','NorthWest');
hold off

%Lets save the plots as both .pdfs and .jpgs in a folder with the contains
%the other results.
orient landscape
if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
    print(fig1,'-dpdf',[year '_' day '_' network '_' station '\' station '_' location '_' channel '_' sensor '_' year '_' day '.pdf']);
else
    print(fig1,'-dpdf',[year '_' day '_' network '_' station '/' station '_' location '_' channel '_' sensor '_' year '_' day '.pdf']);
end
orient portrait
if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
    saveas(fig1,[year '_' day '_' network '_' station '\' station '_' location '_' channel '_' sensor '_' year '_' day '.jpg'],'jpg');
else
    saveas(fig1,[year '_' day '_' network '_' station '/' station '_' location '_' channel '_' sensor '_' year '_' day '.jpg'],'jpg');
end

end
