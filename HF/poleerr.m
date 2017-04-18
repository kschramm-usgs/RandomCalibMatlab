function[perrors] = poleerr(sensor,fre,bestfit,tcal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    normind=find(fre<2,1,'Last');
    w=2*pi*fre;

    if(strcmp(sensor,'KS-54000'))
        %First get the error in the double conjugate pair
        
        perrors=zeros(2,1);
        
        nom=[-7.3199*10^-2; -2.271210*10^1-i*2.710650*10^1; ...
            -2.271210*10^1+i*2.710650*10^1; -5.943130*10^1; -4.800400*10^-3];
        transfer=@(w,p) ((i*w).^2)./((i*w-nom(1)).*(i*w-p(1)).*(i*w-conj(p(1))).*(i*w-bestfit(1)).*(i*w-nom(5)));
        respmodel=@(wf,p) transfer(wf,p)./transfer(w(normind),bestfit(2));
        permin=(2/3)*(2*pi/sqrt(bestfit(2)*conj(bestfit(2))));
        permax=(4/3)*(2*pi/sqrt(bestfit(2)*conj(bestfit(2))));
        indexhi=min(find(fre>1/permin));
        if(length(indexhi)==0)
            indexhi=length(fre);
        end
        indexlow=max(find(fre<1/permax));
        if(length(indexlow)==0)
            indexlow=1;
        end
        l=1;
        for m=indexlow:indexhi
            resfun=@(q) respmodel(w(m),bestfit(2)+q)-tcal(m);
            eramp(l)=real(LMFsolve(resfun,0));
            erphase(l)=imag(LMFsolve(resfun,0));
            l=l+1;
        end
        permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
        permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2));
        perrors(2)=perstdre+i*perstdimag;
    
    %Now get the error in the single pole
    
        transfer=@(w,p) ((i*w).^2)./((i*w-nom(1)).*(i*w-bestfit(2)).*(i*w-conj(bestfit(2))).*(i*w-p(1)).*(i*w-nom(5)));
        respmodel=@(wf,p) transfer(wf,p)./transfer(w(normind),bestfit(1));
        permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
        permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
        indexhi=min(find(fre>1/permin));
        if(length(indexhi)==0)
            indexhi=length(fre);
        end
        indexlow=max(find(fre<1/permax));
        if(length(indexlow)==0)
            indexlow=1;
        end
        l=1;
        clear eramp erphase
        for m=indexlow:indexhi
            resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
            eramp(l)=real(LMFsolve(resfun,0));
            erphase(l)=imag(LMFsolve(resfun,0));
            l=l+1;
        end
        permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
        
        perrors(1)=perstdre;
    
    
    
    elseif(strcmp(sensor,'STS-1'))
        
         nom=[-1.234*10^-2-i*1.234*10^-2; -1.234*10^-2+i*1.234*10^-2; ...
        -3.918*10^1-i*4.912*10^1; -3.918*10^1+i*4.912*10^1];
        transfer=@(w,p) ((i*w).^2)./((i*w-p(1)).*(i*w-conj(p(1))).*(i*w-nom(1)).*(i*w-nom(2)));
        respmodel=@(wf,p) transfer(wf,p)./transfer(w(normind),bestfit(1));
        permin=(2/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
        permax=(4/3)*(2*pi/sqrt(bestfit(1)*conj(bestfit(1))));
        indexhi=min(find(fre>1/permin));
        if(length(indexhi)==0)
            indexhi=length(fre);
        end
        indexlow=max(find(fre<1/permax));
        if(length(indexlow)==0)
            indexlow=1;
        end
        l=1;
        if(indexlow==indexhi)
            indexlow=indexhi-1;
        end
        for m=indexlow:indexhi
            resfun=@(q) respmodel(w(m),bestfit(1)+q)-tcal(m);
            eramp(l)=real(LMFsolve(resfun,0));
            erphase(l)=imag(LMFsolve(resfun,0));
            l=l+1;
        end
        permeanre=(1/abs(permin-permax))*sum(transpose(eramp(2:length(eramp))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdre=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(eramp(2:length(eramp))-permeanre).^2));
        permeanimag=(1/abs(permin-permax))*sum(transpose(erphase(2:length(erphase))).*abs(diff(1./fre(indexlow:indexhi))));
        perstdimag=sqrt((1/abs(permin-permax))*sum(transpose(abs(diff(1./fre(indexlow:indexhi)))).*(erphase(2:length(erphase))-permeanimag).^2))
        perrors=perstdre+i*perstdimag;
    else
        perrors=[];
    end
    
end