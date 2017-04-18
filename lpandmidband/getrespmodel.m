function [respmodel,nom] = getrespmodel(sensor,fre,norm)
%This function returns the response along with the nominal values

    omega=2*pi*fre;


    if(strcmp('STS-1',sensor))
        %Here are the nominal poles
        nom=[-1.234*10^-2-i*1.234*10^-2; -1.234*10^-2+i*1.234*10^-2; ...
            -3.918*10^1-i*4.912*10^1; -3.918*10^1+i*4.912*10^1];
        transfer=@(w,p) ((i*w).^2)./((i*w-p(1)).*(i*w-conj(p(1))).*(i*w-nom(3)).*(i*w-nom(4)));
        respmodel=@(p) transfer(omega,p)./transfer(omega(norm),nom(1));
        nom=nom(1);
    elseif(strcmp(sensor,'STS-2'))
        nom=[-3.7*10^-2-i*3.7*10^-2; -3.7*10^-2+i*3.7*10^-2; ...
            -2.5133*10^2; -1.3104*10^2-i*4.6729*10^2; -1.3104*10^2+i*4.6729*10^2];
        transfer=@(w,p) ((i*w).^2)./((i*w-p(1)).*(i*w-conj(p(1))).*(i*w-nom(3)).*(i*w-nom(4)).*(i*w-nom(5)));
        respmodel=@(p) transfer(omega,p)./transfer(omega(norm),nom(1));
        nom=nom(1);
    elseif(strcmp(sensor,'KS-54000'))
        nom=[-7.3199*10^-2; -2.271210*10^1-i*2.710650*10^1; ...
            -2.271210*10^1+i*2.710650*10^1; -5.943130*10^1; -4.800400*10^-3];
        transfer=@(w,p) ((i*w).^2)./((i*w-p(1)).*(i*w-nom(2)).*(i*w-nom(3)).*(i*w-nom(4)).*(i*w-nom(5)));
        respmodel=@(p) transfer(omega,p)./transfer(omega(norm),nom(1));
        nom=nom(1);
    elseif(strcmp(sensor,'CMG-3T'))
        nom=[-3.701*10^-2-i*3.701*10^-2; -3.701*10^-2+i*3.701*10^-2; ...
            -1.979*10^2+i*1.979*10^2; -1.979*10^2-i*1.979*10^2; -9.111*10^3];
        transfer=@(w,p) ((i*w).^2)./((i*w-p(1)).*(i*w-conj(p(1))).*(i*w-nom(3)).*(i*w-nom(4)).*(i*w-nom(5)));
        respmodel=@(p) transfer(omega,p)./transfer(omega(norm),nom(1));
        nom=nom(1);
    elseif(strcmp(sensor,'TR-240'))
        nom=[-1.815*10^-2-i*1.799*10^-2; -1.815*10^-2+i*1.799*10^-2; -1.73*10^2; ... 
            -1.9*10^2-i*2.31*10^2; -1.9*10^2+i*2.31*10^2; -7.32*10^2-i*1.415*10^3; ...
            -7.32*10^2+i*1.415*10^3];
        transfer=@(w,p) ((i*w).^2)./((i*w-p(1)).*(i*w-conj(p(1))).*(i*w-nom(3)).*(i*w-nom(4)).*(i*w-nom(5)).*(i*w-nom(6)).*(i*w-nom(7)));
        respmodel=@(p) transfer(omega,p)./transfer(omega(norm),nom(1));
        nom=nom(1);
    elseif(strcmp(sensor,'STS-1t5'))
        nom=[-1.222*10^-2-i*1.222*10^-2; -1.222*10^-2+i*1.222*10^-2; -0.021995; -0.026784; ...
            -0.02427184; -3.918*10^1-i*4.912*10^1; -3.918*10^1+i*4.912*10^1];
        transfer=@(w,p) (((i*w-p(4)).^2).*((i*w).^2))./((i*w-p(1)).*(i*w-conj(p(1))).*(i*w-p(2)).*(i*w-p(3)).*(i*w-nom(6)).*(i*w-nom(7)));
        nom=nom(2:5);
        nom(1)=real(nom(1))-i*imag(nom(1));
        respmodel=@(p) transfer(omega,p)./transfer(omega(norm),nom);
    end
end

