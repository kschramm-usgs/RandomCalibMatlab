function [] = writeresp(sensor,info,filename,bestfit,pzerrors,errests)
    %Open output file
    if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
        fid = fopen([char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '\' filename], 'w');
    else
        fid = fopen([char(info{1,6}) '_' char(info{1,7}) '_' char(info{1,1}) '_' char(info{1,2}) '/' filename], 'w');
    end

    %Print station information
    fprintf(fid, '%2s ',char(info{1,1}));
    fprintf(fid, '%4s ',char(info{1,2}));
    fprintf(fid, '%2s ',char(info{1,3}));
    fprintf(fid, '%3s ',char(info{1,4}));
    fprintf(fid, '%4s ',char(info{1,6}));
    fprintf(fid, '%3s \n',char(info{1,7}));

%Print analysis date
    currdate=datevec(now);
    doy=date2doy(currdate(2),currdate(3),currdate(1));
    fprintf(fid, '%14s ','Cal Analyzed: ');
    fprintf(fid, '%4s ',num2str(currdate(1)));
    fprintf(fid,'%3s \n',num2str(doy));
    fprintf(fid, '%13s ','Cal Version: ');
    fprintf(fid, '%1s \n',num2str(1));
    %Print estimated error values
    fprintf(fid, '%29s  %s \n','Best Fit Amplitude Error (dB)',num2str(errests(1)));
    fprintf(fid, '%29s  %s \n','Best Fit Phase Error (degree)',num2str(errests(2)));
    fprintf(fid, '%28s  %s \n','Nominal Amplitude Error (dB)',num2str(errests(3)));
    fprintf(fid, '%28s  %s \n','Nominal Phase Error (degree)',num2str(errests(4)));

    if(strcmp(sensor,'STS-1'))
        fprintf(fid,'%13s \n','Nominal Poles');
        fprintf(fid, '%s \n', num2str(-39.18-1i*49.12));
        fprintf(fid, '%s \n', num2str(conj(-39.18-1i*49.12)));
        fprintf(fid,'%s \n', 'New Resp File');
        rpole1 = sprintf('%+1.6E',-abs(real(bestfit)));
        rpole1 = strrep(rpole1,'E+0','E+');
        rpole1 = strrep(rpole1,'E-0','E-');
        ipole1 = sprintf('%+1.6E',abs(imag(bestfit)));
        ipole1 = strrep(ipole1,'E+0','E+');
        ipole1 = strrep(ipole1,'E-0','E-');
        ipole2 = sprintf('%+1.6E',-abs(imag(bestfit)));
        ipole2 = strrep(ipole2,'E+0','E+');
        ipole2 = strrep(ipole2,'E-0','E-');
        ertermr =sprintf('%+1.6E',abs(real(pzerrors)));
        ertermr = strrep(ertermr,'E+0','E+');
        ertermr = strrep(ertermr,'E-0','E-');
        ertermi =sprintf('%+1.6E',abs(imag(pzerrors)));
        ertermi = strrep(ertermi,'E+0','E+');
        ertermi = strrep(ertermi,'E-0','E-');
        fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','2', rpole1, ipole1, ertermr, ertermi);
        fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','3', rpole1, ipole2, ertermr, ertermi);
    elseif(strcmp(sensor,'KS-54000'))
        fprintf(fid,'%13s \n','Nominal Poles');
        fprintf(fid, '%s \n', num2str(-59.4313));
        fprintf(fid, '%s \n', num2str(conj(-22.7121+1i*27.1065)));
        fprintf(fid, '%s \n', num2str(-22.7121+1i*27.1065));
        fprintf(fid,'%s \n', 'New Resp File');
        rpole1 = sprintf('%+1.6E',real(bestfit(1)));
        rpole1 = strrep(rpole1,'E+0','E+');
        rpole1 = strrep(rpole1,'E-0','E-');
        ipole1 = sprintf('%+1.6E',imag(bestfit(1)));
        ipole1 = strrep(ipole1,'E+0','E+');
        ipole1 = strrep(ipole1,'E-0','E-');
        rpole2 = sprintf('%+1.6E',real(bestfit(2)));
        rpole2 = strrep(rpole1,'E+0','E+');
        rpole2 = strrep(rpole1,'E-0','E-');
        ipole2 = sprintf('%+1.6E',-abs(imag(bestfit(2))));
        ipole2 = strrep(ipole2,'E+0','E+');
        ipole2 = strrep(ipole2,'E-0','E-');
        rpole3 = sprintf('%+1.6E',real(bestfit(2)));
        rpole3 = strrep(rpole1,'E+0','E+');
        rpole3 = strrep(rpole1,'E-0','E-');
        ipole3 = sprintf('%+1.6E',abs(imag(bestfit(2))));
        ipole3 = strrep(ipole2,'E+0','E+');
        ipole3 = strrep(ipole2,'E-0','E-');
        ertermr1 =sprintf('%+1.6E',abs(real(pzerrors(1))));
        ertermr1 = strrep(ertermr1,'E+0','E+');
        ertermr1 = strrep(ertermr1,'E-0','E-');
        ertermi1 =sprintf('%+1.6E',abs(imag(pzerrors(1))));
        ertermi1 = strrep(ertermi1,'E+0','E+');
        ertermi1 = strrep(ertermi1,'E-0','E-');
        ertermr2 =sprintf('%+1.6E',abs(real(pzerrors(2))));
        ertermr2 = strrep(ertermr2,'E+0','E+');
        ertermr2 = strrep(ertermr2,'E-0','E-');
        ertermi2 =sprintf('%+1.6E',abs(imag(pzerrors(2))));
        ertermi2 = strrep(ertermi2,'E+0','E+');
        ertermi2 = strrep(ertermi2,'E-0','E-');
        fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','1', rpole1, ipole1, ertermr1, ertermi1);
        fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','2', rpole2, ipole2, ertermr2, ertermi2);
        fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','3', rpole3, ipole3, ertermr2, ertermi2);
        
    end
    fclose(fid)

end

