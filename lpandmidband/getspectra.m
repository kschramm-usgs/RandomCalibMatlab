function [cropow,inputpow,outputpow,fre]=getspectra(network,station,location,channel,year,day,samplerate,minper,maxper,output,input);
    %This function computes the input power, outputpower,
    %and cross power
    input=decimate(input,samplerate);
    output=decimate(output,samplerate);
    newlength=min(length(input),length(output));
    input=input(1:newlength);
    output=output(1:newlength);
    %Now lets estimate spectra
    [cpow,fre]=mtcsd([output input],floor(length(output)/1.3),1,floor(length(output)/1.3),floor(.8*length(output)/1.3),12,'linear',12);
    inputpow=cpow(:,2,2);
    outputpow=cpow(:,1,1);
    cropow=cpow(:,1,2);
end

