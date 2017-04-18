function [newzer,newpol] = fitpolesGS(hffun,zer,pol,tfdata,fre,sensor)

    newzer=zer;
    newpol=pol;
    
    err=Inf;
    
    
    if(strcmp(sensor,'KS-54000'))
        for pol1ind=.5*pol(1):.1*pol(1):1.5*pol(1)
            for repol2ind=.5*real(pol(2)):.1*real(pol(2)):1.5*real(pol(2))
                for impol2ind=.5*imag(pol(2)):.1*imag(pol(2)):1.5*imag(pol(2))
                    perval=hffun([pol1ind repol2ind+1i*impol2ind]);
                    normind=find(fre<2,1,'Last');
                    perval=perval/perval(normind);
                    errtemp=sum(abs(perval-tfdata).^2);
                    if(errtemp<err)
                        newpol=[pol1ind repol2ind+1i*impol2ind];
                        err=errtemp;
                    end
                    
                    
                end
            end
        end
    elseif(strcmp(sensor,'STS-1'))
        
        for repol1ind=.5*real(pol(1)):.1*real(pol(1)):1.5*real(pol(1))
            for impol1ind=.5*imag(pol(1)):.1*imag(pol(1)):1.5*imag(pol(1))
                perval=hffun([repol1ind+1i*impol1ind]);
                normind=find(fre<2,1,'Last');
                perval=perval/perval(normind);
                errtemp=sum(abs(perval-tfdata).^2);
                if(errtemp<err)
                    newpol=[repol1ind+1i*impol1ind];
                    err=errtemp;
                end
            end
        end

    end
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    








end

