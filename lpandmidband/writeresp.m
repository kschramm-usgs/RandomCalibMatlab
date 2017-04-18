function [wrgood] = writeresp(filename,sensortemp,nom,bftp1,yeartemp,networktemp,stationtemp,locationtemp,channeltemp,daytemp,amperror,phaserror,perrors,phasernom,ampernom,ver)
%Here we write out the details of the resp file

wrgood=0;
%Open output file
if(strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64'))
    fid = fopen([yeartemp '_' daytemp '_' networktemp '_' stationtemp '\' filename], 'w');
else
    fid = fopen([yeartemp '_' daytemp '_' networktemp '_' stationtemp '/' filename], 'w');
end

%Print station information
fprintf(fid, '%2s ',networktemp);
fprintf(fid, '%4s ',stationtemp);
fprintf(fid, '%2s ',locationtemp);
fprintf(fid, '%3s ',channeltemp);
fprintf(fid, '%4s ',yeartemp);
fprintf(fid, '%3s \n',daytemp);

%Print analysis date
currdate=datevec(now);
doy=date2doy(currdate(2),currdate(3),currdate(1));
fprintf(fid, '%14s ','Cal Analyzed: ');
fprintf(fid, '%4s ',num2str(currdate(1)));
fprintf(fid,'%3s \n',num2str(doy));
fprintf(fid, '%13s ','Cal Version: ');
fprintf(fid, '%1s \n',num2str(ver));
%Print estimated error values
fprintf(fid, '%29s  %s \n','Best Fit Amplitude Error (dB)',num2str(amperror));
fprintf(fid, '%29s  %s \n','Best Fit Phase Error (degree)',num2str(phaserror));
fprintf(fid, '%28s  %s \n','Nominal Amplitude Error (dB)',num2str(ampernom));
fprintf(fid, '%28s  %s \n','Nominal Phase Error (degree)',num2str(phasernom));

%Go through and print the new response based on the model type

if(strcmp(sensortemp,'STS-1'))
   fprintf(fid,'%13s \n','Nominal Poles');
   fprintf(fid, '%s \n', num2str(nom(1)));
   fprintf(fid, '%s \n', num2str(conj(nom(1))));
   fprintf(fid,'%s \n', 'New Resp File');
   fprintf(fid, '%s     %s                      %s\n','B053F09','Number of zeroes:','2');
   fprintf(fid, '%s     %s                       %s\n','B053F14','Number of poles:','4');
   fprintf(fid, '%s \n','#              Complex zeroes:');
   fprintf(fid, '%s \n','#              i  real          imag          real_error    imag_error');
   fprintf(fid, '%s \n','B053F10-13    0  +0.000000E+00  +0.000000E+00  +0.000000E+00  +0.000000E+00');
   fprintf(fid, '%s \n','B053F10-13    1  +0.000000E+00  +0.000000E+00  +0.000000E+00  +0.000000E+00');
   fprintf(fid, '%s \n','#              Complex poles:');
   fprintf(fid, '%s \n','#              i  real          imag          real_error    imag_error');
   rpole1 = sprintf('%+1.6E',-abs(real(bftp1)));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%+1.6E',abs(imag(bftp1)));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%+1.6E',-abs(imag(bftp1)));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
   ertermr =sprintf('%+1.6E',abs(real(perrors)));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   ertermi =sprintf('%+1.6E',abs(imag(perrors)));
   ertermi = strrep(ertermi,'E+0','E+');
   ertermi = strrep(ertermi,'E-0','E-');
   fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','0', rpole1, ipole1, ertermr, ertermi);
   fprintf(fid, '%s    %s  %s  %s  %s  %s\n','B053F15-18','1', rpole1, ipole2, ertermr, ertermi);
   fprintf(fid, '%s \n','B053F15-18     2  -3.918000E+01  +4.912000E+01  +0.000000E+00  +0.000000E+00');
   fprintf(fid, '%s \n','B053F15-18     3  -3.918000E+01  -4.912000E+01  +0.000000E+00  +0.000000E+00');
elseif(strcmp(sensortemp,'STS-1t5'))
   fprintf(fid,'%13s \n','Nominal Zeros');
   fprintf(fid,'%s \n', num2str(nom(4)));
   fprintf(fid,'%s \n', num2str(nom(4)));
   fprintf(fid,'%13s \n','Nominal Poles');
   fprintf(fid, '%s \n', num2str(nom(1)));
   fprintf(fid, '%s \n', num2str(conj(nom(1))));
   fprintf(fid, '%s \n', num2str(nom(2)));
   fprintf(fid, '%s \n', num2str(nom(3))); 
   fprintf(fid,'%s \n', 'New Resp File');
   fprintf(fid, '%s     %s                      %s\n','B053F09','Number of zeroes:','4');
   fprintf(fid, '%s     %s                       %s\n','B053F14','Number of poles:','6');
   fprintf(fid, '%s \n','#              Complex zeroes:');
   fprintf(fid, '%s \n','#              i  real          imag          real_error    imag_error');
   fprintf(fid, '%s \n','B053F10-13     0  +0.000000E+00  +0.000000E+00  +0.000000E+00  +0.000000E+00');
   fprintf(fid, '%s \n','B053F10-13     1  +0.000000E+00  +0.000000E+00  +0.000000E+00  +0.000000E+00');
   rpole1 = sprintf('%1.6E',-abs(real(bftp1(4))));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%1.6E',abs(imag(bftp1(4))));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   if(imag(bftp1(4))==0)
   ipole2 = sprintf('%1.6E',abs(imag(bftp1(4))));
   else
       ipole2 = sprintf('%1.6E',-abs(imag(bftp1(4))));
   end
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
   erterm =sprintf('%1.6E',0);
   erterm = strrep(erterm,'E+0','E+');
   erterm = strrep(erterm,'E-0','E-');
   ertermr =sprintf('%1.6E',abs(real(perrors(4))));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   fprintf(fid, '%s     %s  %s  %s  %s  %s\n','B053F10-13','2', rpole1, ipole1, ertermr, erterm);
   fprintf(fid, '%s     %s  %s  %s  %s  %s\n','B053F10-13','3', rpole1, ipole2, ertermr, erterm);
   fprintf(fid, '%s \n','#              Complex poles:');
   fprintf(fid, '%s \n','#              i  real          imag          real_error    imag_error');
   rpole1 = sprintf('%1.6E',-abs(real(bftp1(1))));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%1.6E',abs(imag(bftp1(1))));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%1.6E',-abs(imag(bftp1(1))));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
   erterm =sprintf('%1.6E',0);
   erterm = strrep(erterm,'E+0','E+');
   erterm = strrep(erterm,'E-0','E-');
   ertermr =sprintf('%1.6E',abs(real(perrors(1))));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   ertermi =sprintf('%1.6E',abs(imag(perrors(1))));
   ertermi = strrep(ertermi,'E+0','E+');
   ertermi = strrep(ertermi,'E-0','E-');
   fprintf(fid, '%s     %s  %s  %s  %s  %s\n','B053F15-18','0', rpole1, ipole1, ertermr, ertermi);
   fprintf(fid, '%s     %s  %s  %s  %s  %s\n','B053F15-18','1', rpole1, ipole2, ertermr, ertermi);
   rpole1 = sprintf('%1.6E',-abs(real(bftp1(2))));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%1.6E',abs(imag(bftp1(2))));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%1.6E',-abs(imag(bftp1(2))));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
   erterm =sprintf('%1.6E',0);
   erterm = strrep(erterm,'E+0','E+');
   erterm = strrep(erterm,'E-0','E-');
   ertermr =sprintf('%1.6E',abs(real(perrors(2))));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   fprintf(fid, '%s     %s  %s  %s  %s  %s\n','B053F15-18','2', rpole1, ipole1, ertermr, erterm);
   rpole1 = sprintf('%1.6E',-abs(real(bftp1(3))));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%1.6E',abs(imag(bftp1(3))));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%1.6E',-abs(imag(bftp1(3))));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
   erterm =sprintf('%1.6E',0);
   erterm = strrep(erterm,'E+0','E+');
   erterm = strrep(erterm,'E-0','E-');
   ertermr =sprintf('%1.6E',abs(real(perrors(3))));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   fprintf(fid, '%s     %s  %s  %s  %s  %s\n','B053F15-18','3', rpole1, ipole1, ertermr, erterm);
   fprintf(fid, '%s \n','B053F15-18     4  -3.918000E+01  +4.912000E+01  +0.000000E+00  +0.000000E+00');
   fprintf(fid, '%s \n','B053F15-18     5  -3.918000E+01  -4.912000E+01  +0.000000E+00  +0.000000E+00');
elseif(strcmp(sensortemp,'STS-2'))
   fprintf(fid,'%13s \n','Nominal Poles');
   fprintf(fid, '%s \n', num2str(nom(1)));
   fprintf(fid, '%s \n', num2str(conj(nom(1))));
   fprintf(fid,'%s \n', 'New Resp File');
   rpole1 = sprintf('%+1.6E',-abs(real(bftp1)));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%+1.6E',abs(imag(bftp1)));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%+1.6E',-abs(imag(bftp1)));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
   erterm =sprintf('%+1.6E',0);
   erterm = strrep(erterm,'E+0','E+');
   erterm = strrep(erterm,'E-0','E-');
   ertermr =sprintf('%+1.6E',abs(real(perrors)));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   ertermi =sprintf('%+1.6E',abs(imag(perrors)));
   ertermi = strrep(ertermi,'E+0','E+');
   ertermi = strrep(ertermi,'E-0','E-');
   fprintf(fid, '%s    %s %s %s  %s  %s\n','B053F15-18','0', rpole1, ipole1, ertermr, ertermi);
   fprintf(fid, '%s    %s %s %s  %s  %s\n','B053F15-18','1', rpole1, ipole2, ertermr, ertermi);
elseif(strcmp(sensortemp,'KS-54000'))
   fprintf(fid,'%13s \n','Nominal Poles');
   fprintf(fid, '%s \n', num2str(nom(1)));
      fprintf(fid,'%s \n', 'New Resp File');
   rpole1 = sprintf('%+1.6E',real(bftp1(1)));
    rpole1 = strrep(rpole1,'E+0','E+');
    rpole1 = strrep(rpole1,'E-0','E-');
   
    ertermr =sprintf('%+1.6E',abs(real(perrors)));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   ertermi =sprintf('%+1.6E',0);
   ertermi = strrep(ertermi,'E+0','E+');
   ertermi = strrep(ertermi,'E-0','E-');
    fprintf(fid, '%s    %s %s  %s  %s  %s\n','B053F15-18','4', rpole1, ertermi, ertermr, ertermi);
elseif(strcmp(sensortemp,'CMG-3T'))
   fprintf(fid,'%13s \n','Nominal Poles');
   fprintf(fid, '%s \n', num2str(nom(1)));
   fprintf(fid, '%s \n', num2str(conj(nom(1))));
      fprintf(fid,'%s \n', 'New Resp File');
   rpole1 = sprintf('%+1.6E',-abs(real(bftp1)));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%+1.6E',abs(imag(bftp1)));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%+1.6E',-abs(imag(bftp1)));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
    ertermr =sprintf('%+1.6E',abs(real(perrors)));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   ertermi =sprintf('%+1.6E',abs(imag(perrors)));
   ertermi = strrep(ertermi,'E+0','E+');
   ertermi = strrep(ertermi,'E-0','E-');
   fprintf(fid, '%s    %s %s  %s  %s  %s\n','B053F15-18','0', rpole1, ipole1, ertermr, ertermi);
   fprintf(fid, '%s    %s %s  %s  %s  %s\n','B053F15-18','1', rpole1, ipole2, ertermr, ertermi);
elseif(strcmp(sensortemp,'TR-240'))
   fprintf(fid,'%13s \n','Nominal Poles');
   fprintf(fid, '%s \n', num2str(nom(1)));
   fprintf(fid, '%s \n', num2str(conj(nom(1))));
      fprintf(fid,'%s \n', 'New Resp File');
   rpole1 = sprintf('%+1.6E',-abs(real(bftp1)));
   rpole1 = strrep(rpole1,'E+0','E+');
   rpole1 = strrep(rpole1,'E-0','E-');
   ipole1 = sprintf('%+1.6E',abs(imag(bftp1)));
   ipole1 = strrep(ipole1,'E+0','E+');
   ipole1 = strrep(ipole1,'E-0','E-');
   ipole2 = sprintf('%+1.6E',-abs(imag(bftp1)));
   ipole2 = strrep(ipole2,'E+0','E+');
   ipole2 = strrep(ipole2,'E-0','E-');
    ertermr =sprintf('%+1.6E',abs(real(perrors)));
   ertermr = strrep(ertermr,'E+0','E+');
   ertermr = strrep(ertermr,'E-0','E-');
   ertermi =sprintf('%+1.6E',abs(imag(perrors)));
   ertermi = strrep(ertermi,'E+0','E+');
   ertermi = strrep(ertermi,'E-0','E-');
   fprintf(fid, '%s    %s %s  %s  %s  %s\n','B053F15-18','0', rpole1, ipole1, ertermr, ertermi);
   fprintf(fid, '%s    %s %s %s  %s  %s\n','B053F15-18','1', rpole1, ipole2, ertermr, ertermi);
end

%Now we write the respfile
fclose(fid)



end

