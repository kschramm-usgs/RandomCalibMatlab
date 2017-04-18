%This program does a broadband cal analysis


%Get the files we want to do the cals on
[bhdatafile,bcdatafile,sensor]=getcalfiles('caldriver.txt');

numofcals=length(bhdatafile(:,1));

for calind=1:numofcals
    %Lets get the data from each cal and analyze
    disp('Reading the data.  This could take a while.');
    [bhdata,bcdata,info]=getdata(bhdatafile{calind,1},bcdatafile{calind,1});
     
    mkdir([char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2})]);
    filename=['ZPHF_' char(info{1,1}) '_' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_' char(sensor{calind,1}) '_' char(info{1,6}) char(info{1,7})];
    filename = strrep(filename,'-',''); 
    
    if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
        copyfile(bhdatafile{calind,1},[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '\DATA' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_'  char(info{1,6}) '_' char(info{1,7}) '.seed']);
        copyfile(bcdatafile{calind,1},[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '\DATA' char(info{1,2}) '_BC' char(info{1,3}) '_'  char(info{1,6}) '_' char(info{1,7}) '.seed']);
    else
        copyfile(bhdatafile{calind,1},[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '/DATA' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_'  char(info{1,6}) '_' char(info{1,7}) '.seed']);
        copyfile(bcdatafile{calind,1},[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '/DATA' char(info{1,2}) '_BC' char(info{1,3}) '_'  char(info{1,6}) '_' char(info{1,7}) '.seed']);
    end

    if(strcmp(char(sensor{calind,1}),'KS-54000') || strcmp(char(sensor{calind,1}),'STS-1')) 
        fitpz='TRUE';
    else
        fitpz='FALSE';
    end
         
         
         
         
    disp(['Looks like we are analyzing a ' char(sensor{calind,1}) '.']);
    disp('Computing Spectra.');
    [inpow,outpow,cpow,fre]=getspectra(bhdata,bcdata,info);
    if(info{1,5}==20)
        indfre=find(fre>.5);
    else
        indfre=find(fre>1);
    end
    fre=fre(indfre);
    inpow=inpow(indfre);
    outpow=outpow(indfre);
    cpow=cpow(indfre);
    if(info{1,5}==20)
        normind=find(fre<2,1,'Last');
        normindphase=find(fre<1.83,1,'Last');
    else
        normind=find(fre<5,1,'Last');
        normindphase=find(fre<2,1,'Last');
    end
    
        

    
    [z,p,g]=getrespmodel(char(sensor{calind,1}));
    if(strcmp(char(sensor{calind,1}),'KS-54000'))
        hffun=gethffun(z,p,sensor,fre);
        ztf=[];
        ptf=p(1:2);
        ampnom=hffun(ptf).*conj(hffun(ptf));
        ampnom=ampnom/ampnom(normind);
        phasenom=angle(hffun(ptf))*180/pi;
        phasenom=phasenom-phasenom(normindphase);
    elseif(strcmp(char(sensor{calind,1}),'STS-1'))
        hffun=gethffun(z,p,sensor,fre);
        ztf=[];
        ptf=p(3);
        ampnom=hffun(ptf).*conj(hffun(ptf));
        ampnom=ampnom/ampnom(normind);
        phasenom=angle(hffun(ptf))*180/pi;
        phasenom=phasenom-phasenom(normindphase);
        
    else
        iome=1i*2*pi*fre;
        hfnom=zeros(length(fre),1)+1;
        for zind=1:length(z)
            
     
            hfnom=hfnom.*(iome-z(zind));
        end
        for pind=1:length(p)
      
            hfnom=hfnom./(iome-p(pind));
        end
        ampnom=hfnom.*conj(hfnom);
        ampnom=ampnom/ampnom(normind);
        phasenom=angle(hfnom)*180/pi;
        phasenom=phasenom-phasenom(normindphase);
    end
    
    
    
    
        
        
     cdata=(2*pi*fre).*cpow./inpow;
   % cdata=cpow./inpow;
    cdata=cdata./cdata(normind);
    
   phasedata=angle(cdata)*180/pi;
    phasedata=phasedata-phasedata(normindphase);
    
    if(strcmp(fitpz,'TRUE'))
        disp('Fitting poles and zeros');
        [znew,pnew]=fitpolesGS(hffun,ztf,ptf,cdata,fre,char(sensor{calind,1}));
        normval=hffun(pnew);
        normval=normval(normind);
        normfunphase=angle(hffun(pnew))*180/pi;
        tamp=@(p) hffun(p).*conj(hffun(p))./(normval.*conj(normval));
        tphase=@(p) angle(hffun(p))*180/pi -normfunphase(normindphase);
        resamp=@(p) 10*log10(tamp(p))-10*log10(cdata.*conj(cdata));
        resphase=@(p) tphase(p)-phasedata;
        resid=@(p) [resamp(p); resphase(p)];
        residfit=@(p) sum(resid(p).*resid(p).*[0; diff(fre); 0; diff(fre)]);
    else
        disp('We can not fit poles and zeros, but will still estimate in-band error');
        normval=hfnom;
        normval=normval(normind);
        normfunphase=angle(hfnom)*180/pi;
        tamp= hfnom.*conj(hfnom)./(normval.*conj(normval));
        tphase=angle(hfnom)*180/pi -normfunphase(normindphase);
        resamp= 10*log10(tamp)-10*log10(cdata.*conj(cdata));
        resphase= tphase-phasedata;
        resid= [resamp; resphase];
        residfit= sum(resid.*resid.*[0; diff(fre); 0; diff(fre)]);
    end
    
    
    
    if(strcmp(fitpz,'TRUE'))
        [bestfit,b,c]=LMFsolve(residfit,pnew,'Display',0,'MaxIter',2000,'XTol',1*10^-12);
        phasebf=angle(hffun(bestfit))*180/pi;
        phasebf=phasebf-phasebf(normindphase);
        ampbf=hffun(bestfit).*conj(hffun(bestfit));
        ampbf=ampbf./(ampbf(normind));
    end
   

        errests=zeros(4,1);
        if(strcmp(fitpz,'TRUE'))
            errests(2)=sqrt(sum(resphase(bestfit).*resphase(bestfit).*[0; diff(fre)])); 
            errests(1)=sqrt(sum(resamp(bestfit).*resamp(bestfit).*[0; diff(fre)]));
            errests(4)=sqrt(sum(resphase(ptf).*resphase(ptf).*[0; diff(fre)])); 
            errests(3)=sqrt(sum(resamp(ptf).*resamp(ptf).*[0; diff(fre)])); 
        else
            errests(4)=sqrt(sum(resphase.*resphase.*[0; diff(fre)])); 
            errests(3)=sqrt(sum(resamp.*resamp.*[0; diff(fre)]));
        end
        
        
  
        if(strcmp(fitpz,'TRUE'))
            polerrbf=poleerr(char(sensor{calind,1}),fre,bestfit,cdata);
        end
    
    
    
    disp('Making some pictures');
     
       
    fig1=figure(1)
    clf
    subplot(2,1,1)
    p1=semilogx(fre,10*log10(ampnom),'k','LineWidth',3);
    hold on
    p2=semilogx(fre,10*log10(cdata.*conj(cdata)),'b','LineWidth',3);
    if(strcmp(fitpz,'TRUE'))
        p3=semilogx(fre,10*log10(ampbf),'r','LineWidth',3);
    end

    xlabel('Frequency (Hz)','FontSize',18);
    set(gca,'FontSize',18);
    ylabel('Amplitude (dB)','FontSize',18);
    xlim([min(fre) max(fre)]);
    title(['Cal Amplitude Response ' char(info{1,3}) ' ' char(info{1,2}) ...
        ' ' char(info{1,4}) ' ' char(info{1,7}) ' ' char(info{1,6})]);
  
   if(strcmp(fitpz,'TRUE'))
     legend([p1 p2 p3],'Scaled Nominal','Calibration','Best-Fit','FontSize',18,'Location','SouthWest');
   else
       legend([p1 p2],'Scaled Nominal','Calibration','FontSize',18,'Location','SouthWest');
   end
  
   
    subplot(2,1,2)
    p1=semilogx(fre,phasenom,'k','LineWidth',3);
    hold on
    p2=semilogx(fre,phasedata,'b','LineWidth',3);
    if(strcmp(fitpz,'TRUE'))
        p3=semilogx(fre,phasebf,'r','LineWidth',3);
    end

    xlim([min(fre) max(fre)]);
    xlabel('Frequency (Hz)','FontSize',18);
    set(gca,'FontSize',18);
    ylabel('Phase (degrees)','FontSize',18);
    title(['Phase Response ' char(info{1,3}) ' ' char(info{1,2}) ...
        ' ' char(info{1,4}) ' ' char(info{1,7}) ' ' char(info{1,6})]);
    if(strcmp(fitpz,'TRUE'))
        legend([p1 p2 p3],'Scaled Nominal','Calibration','Best-Fit','FontSize',18,'Location','SouthWest');
    else
        legend([p1 p2],'Scaled Nominal','Calibration','FontSize',18,'Location','SouthWest');
    end
  
   orient landscape
    if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
        print(fig1,'-dpdf',[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '\HF' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_'  char(info{1,6}) '_' char(info{1,7}) '.pdf']);
    else
        print(fig1,'-dpdf',[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '/HF' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_'  char(info{1,6}) '_' char(info{1,7}) '.pdf']);
    end
    orient portrait
    if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
        saveas(fig1,[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '\HF' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_'  char(info{1,6}) '_' char(info{1,7}) '.jpg'],'jpg');
    else
        saveas(fig1,[char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '\HF' char(info{1,2}) '_' char(info{1,3}) '_' char(info{1,4}) '_'  char(info{1,6}) '_' char(info{1,7}) '.jpg'],'jpg');
    end
    
    disp('Saving the results');
    
    if(strcmp(fitpz,'TRUE'))
        writeresp(char(sensor{calind,1}),info,filename,bestfit,polerrbf,errests);
    else
        writeresp(char(sensor{calind,1}),info,filename,[],[],errests);
    end
    
    
end
fclose('all');