function [ fhfun] = gethffun(zer,pol,sensor,fre)
%Here we get the high frequency function for a KS-54000 or an STS-1

iome=1i*2*pi*fre;


    if(strcmp(sensor,'KS-54000'))
        fhfun=@(p) (iome-zer(1)).*(iome-zer(2))./((iome-p(2)).*(iome-conj(p(2))).*(iome-p(1)).*(iome-pol(4)).*(iome-pol(5)));
    elseif(strcmp(sensor,'STS-1'))
        fhfun=@(p) (iome-zer(1)).*(iome-zer(2))./((iome-p(1)).*(iome-conj(p(1))).*(iome-pol(1)).*(iome-pol(2)));
    end
    






end

