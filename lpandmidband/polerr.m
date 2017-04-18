function perrors=polerr(bestfit,tcal,fre,sensor,norm,respmodel)
%Here we estimate the error in the pole zero model by estimating deviations
%and integrating to get a sigma pole
    w=2*p1i*fre;
    perrors=[];
    if(strcmp(sensor,'STS-1'))
    
        nom=[-1.234*10^-2-1i*1.234*10^-2; -1.234*10^-2+1i*1.234*10^-2; ...
            -3.918*10^1-1i*4.912*10^1; -3.918*10^1+1i*4.912*10^1];
        transfer=@(w,p) ((1i*w).^2)./((1i*w-p(1)).*(1i*w-conj(p(1))).*(1i*w-nom(3)).*(1i*w-nom(4)));
        respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
        permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
        permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
        indexhi=min(find(fre>1/permin));
        indexlow=max(find(fre<1/permax));
        l=1;
        for m=indexlow:indexhi
            resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
            eramp(l)=real(LMFsolve(resfun,0));
            erphase(l)=imag(LMFsolve(resfun,0));
            l=l+1;
        end
        permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
        permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
        perrors=perstdre+11i*perstdimag;

    
    
    
    
elseif(strcmp(sensor,'STS-1t5'))
    %Estimate long period pole error
    nom=[-1.234*10^-2-1i*1.234*10^-2; -1.234*10^-2+1i*1.234*10^-2; -0.021995; -0.026784; ...
         -0.02427184; -3.918*10^1-1i*4.912*10^1; -3.918*10^1+1i*4.912*10^1];
    transfer=@(w,p) (((1i*w-bestfit(4)).^2).*((1i*w).^2))./((1i*w-p(1)).*(1i*w-conj(p(1))).*(1i*w-bestfit(2)).*(1i*w-bestfit(3)).*(1i*w-nom(6)).*(1i*w-nom(7)));
    nom=nom(2:5);
    nom(1)=real(nom(1))-1i*imag(nom(1));
    
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
    permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    clear eramp erphase
    for m=indexlow:indexhi

          resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));

        l=l+1;
    end
    try
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
    perrors(1)=perstdre+1i*perstdimag;
    catch
        perrors(1)=0;
    end
    

    %Estimate the first mid-band pole
    nom=[-1.234*10^-2-1i*1.234*10^-2; -1.234*10^-2+1i*1.234*10^-2; -0.021995; -0.026784; ...
         -0.02427184; -3.918*10^1-1i*4.912*10^1; -3.918*10^1+1i*4.912*10^1];
    transfer=@(w,p) (((1i*w-bestfit(4)).^2).*((1i*w).^2))./((1i*w-bestfit(1)).*(1i*w-conj(bestfit(1))).*(1i*w-p(1)).*(1i*w-bestfit(3)).*(1i*w-nom(6)).*(1i*w-nom(7)));
    nom=nom(2:5);
    nom(1)=real(nom(1))-1i*imag(nom(1));
    
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(2));
    permin=(2/3)*(2*pi/sqrt(bestfit(2)*conj(bestfit(2))));
    permax=(4/3)*(2*pi/sqrt(bestfit(2)*conj(bestfit(2))));
    if(permax>900)
        permax=900;
    end
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    clear eramp erphase
    for m=indexlow:indexhi
           resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    try
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    perrors(2)=perstdre;
    catch
        perrors(2)=0;
    end
    %Estimate the second mid-band pole
    nom=[-1.234*10^-2-1i*1.234*10^-2; -1.234*10^-2+1i*1.234*10^-2; -0.021995; -0.026784; ...
         -0.02427184; -3.918*10^1-1i*4.912*10^1; -3.918*10^1+1i*4.912*10^1];
    transfer=@(w,p) (((1i*w-bestfit(4)).^2).*((1i*w).^2))./((1i*w-bestfit(1)).*(1i*w-conj(bestfit(1))).*(1i*w-bestfit(2)).*(1i*w-p(1)).*(1i*w-nom(6)).*(1i*w-nom(7)));
    nom=nom(2:5);
    nom(1)=real(nom(1))-1i*imag(nom(1));
    
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(3));
    permin=(2/3)*(2*pi/sqrt(bestfit(3)*conj(bestfit(3))));
    permax=(4/3)*(2*pi/sqrt(bestfit(3)*conj(bestfit(3))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    if(length(indexlow)==0)
        indexlow=1;
    end
    l=1;
    clear eramp erphase
    for m=indexlow:indexhi
          resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
         % erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    try
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    perrors(3)=perstdre;
    catch
        perrors(3)=0;
    end
    
    %Estimate the mid-band double zero
    nom=[-1.234*10^-2-1i*1.234*10^-2; -1.234*10^-2+1i*1.234*10^-2; -0.021995; -0.026784; ...
         -0.02427184; -3.918*10^1-1i*4.912*10^1; -3.918*10^1+1i*4.912*10^1];
    transfer=@(w,p) (((1i*w-p(1)).^2).*((1i*w).^2))./((1i*w-bestfit(1)).*(1i*w-conj(bestfit(1))).*(1i*w-bestfit(2)).*(1i*w-bestfit(3)).*(1i*w-nom(6)).*(1i*w-nom(7)));
    nom=nom(2:5);
    nom(1)=real(nom(1))-1i*imag(nom(1));
    
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
    permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    clear eramp erphase
    for m=indexlow:indexhi
        resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    try
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
    perrors(4)=perstdre+1i*perstdimag;
    catch
        perrors(4)=0;
    end
    

    
elseif(strcmp(sensor,'KS-54000'))
     nom=[-7.3199*10^-2; -2.271210*10^1-1i*2.710650*10^1; ...
        -2.271210*10^1+1i*2.710650*10^1; -5.943130*10^1; -4.800400*10^-3];
    transfer=@(w,p) ((1i*w).^2)./((1i*w-p(1)).*(1i*w-nom(2)).*(1i*w-nom(3)).*(1i*w-nom(4)).*(1i*w-nom(5)));
     respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
    permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    clear eramp erphase
    for m=indexlow:indexhi
        resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    try
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
    perrors=perstdre;
    catch
       perrors=0;
    end
    
elseif(strcmp(sensor,'STS-2'))
    
    nom=[-3.7*10^-2-1i*3.7*10^-2; -3.7*10^-2+1i*3.7*10^-2; ...
        -2.5133*10^2; -1.3104*10^2-1i*4.6729*10^2; -1.3104*10^2+1i*4.6729*10^2];
    transfer=@(w,p) ((1i*w).^2)./((1i*w-p(1)).*(1i*w-conj(p(1))).*(1i*w-nom(3)).*(1i*w-nom(4)).*(1i*w-nom(5)));
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
    permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    for m=indexlow:indexhi
        resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
    perrors=perstdre+1i*perstdimag;
    
    
elseif(strcmp(sensor,'CMG-3T'))
    nom=[-3.701*10^-2-1i*3.701*10^-2; -3.701*10^-2+1i*3.701*10^-2; ...
        -1.979*10^2+1i*1.979*10^2; -1.979*10^2-1i*1.979*10^2; -9.111*10^3];
    transfer=@(w,p) ((1i*w).^2)./((1i*w-p(1)).*(1i*w-conj(p(1))).*(1i*w-nom(3)).*(1i*w-nom(4)).*(1i*w-nom(5)));
    
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
    permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    for m=indexlow:indexhi
        resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
    perrors=perstdre+1i*perstdimag;
    
elseif(strcmp(sensor,'TR-240'))
     nom=[-1.815*10^-2-1i*1.799*10^-2; -1.815*10^-2+1i*1.799*10^-2; -1.73*10^2; ... 
        -1.9*10^2-1i*2.31*10^2; -1.9*10^2+1i*2.31*10^2; -7.32*10^2-1i*1.415*10^3; ...
        -7.32*10^2+1i*1.415*10^3];
    transfer=@(w,p) ((1i*w).^2)./((1i*w-p(1)).*(1i*w-conj(p(1))).*(1i*w-nom(3)).*(1i*w-nom(4)).*(1i*w-nom(5)).*(1i*w-nom(6)).*(1i*w-nom(7)));
    respmodel=@(wf,p) transfer(wf,p)./transfer(w(norm),bestfit(1));
    permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
    indexhi=min(find(fre>1/permin));
    indexlow=max(find(fre<1/permax));
    l=1;
    for m=indexlow:indexhi
        resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
          eramp(l)=real(LMFsolve(resfun,0));
          erphase(l)=imag(LMFsolve(resfun,0));
        l=l+1;
    end
    permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
    permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
    perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
    perrors=perstdre+1i*perstdimag;
    
end



perrors=3*perrors;





end

