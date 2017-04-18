function [inpow,outpow,cpow,fre] = getspectra(bhdata,bcdata,info)


    samplerate=info{1,5};
    indatalp=decimate(bcdata,samplerate);
    outdatalp=decimate(bhdata,samplerate);

    [cpowlp,frelp]=mtcsd([outdatalp indatalp],floor(length(outdatalp)/1.3),1, ...
        floor(length(outdatalp)/1.3),floor(.8*length(outdatalp)/1.3), ...
        12,'linear',12);
    inpowlp=cpowlp(:,2,2);
    outpowlp=cpowlp(:,1,1);
    cpowlp=cpowlp(:,1,2);
    
    
    
    outdatamp=bhdata(1:240*samplerate);
    indatamp=bcdata(1:240*samplerate);
    outdatamp=decimate(outdatamp,8);
    indatamp=decimate(indatamp,8);
    
    [cpowmp,fremp]=mtcsd([outdatamp indatamp],floor(length(outdatamp)/1.3),floor(samplerate/8), ...
        floor(length(outdatamp)/1.3),floor(.8*length(outdatamp)/1.3), ...
        12,'linear',12);
    
    inpowmp=cpowmp(:,2,2);
    outpowmp=cpowmp(:,1,1);
    cpowmp=cpowmp(:,1,2);
    
    
    
    outdatasp=bhdata(1:60*samplerate);
    indatasp=bcdata(1:60*samplerate);
    [cpowsp,fresp]=mtcsd([outdatasp indatasp],floor(length(outdatasp)/1.3),samplerate, ...
        floor(length(outdatasp)/1.3),floor(.8*length(outdatasp)/1.3), ...
        12,'linear',12);
    
    inpowsp=cpowsp(:,2,2);
    outpowsp=cpowsp(:,1,1);
    cpowsp=cpowsp(:,1,2);
    
    
    
  indlp=min(find(frelp>.4));  
  indmpstart=min(find(fremp>1.8));
  indmpend=max(find(fremp<.4));
  indspend=max(find(fresp<1.8));
  indspstart=min(find(fresp>.9*samplerate/2));
  
  fre=[frelp(1:indlp); fremp(indmpend:indmpstart); fresp(indspend:indspstart)];
  outpow=[outpowlp(1:indlp); outpowmp(indmpend:indmpstart); outpowsp(indspend:indspstart)];
  inpow=[inpowlp(1:indlp); inpowmp(indmpend:indmpstart); inpowsp(indspend:indspstart)];
  cpow=[cpowlp(1:indlp); cpowmp(indmpend:indmpstart); cpowsp(indspend:indspstart)];
    
    

    
    
    

end

