function [pguess] = priorsol(resid,nom,pert,dev)
%This function solves for an initial solution which is used as a prior
%later on.  This is a coarse global solver

pguess=[];

%Here we solve for double complex pole
if(length(nom)==1)
    if(imag(nom(1))~=0)
        rpart=[(1+pert)*real(nom(1)):dev:2*dev];
        ipart=[(1+pert)*imag(nom(1)):dev:2*dev];
        for m=1:length(rpart)
            for n=1:length(ipart)
                erm(m,n)=transpose(resid([rpart(m)+i*ipart(n)]))*resid([rpart(m)+i*ipart(n)]);
            end
        end
        [erroval,index2]=min(min(erm(:,:)));
        [erroval,index1]=min(erm(:,index2));
        bftp1=rpart(index1)+i*ipart(index2);
        pguess=[bftp1];
    end
end

%Here is one real long-period pole (e.g. KS-54000)
if(length(nom)==1)
    if(imag(nom(1))==0)
        rpart=[(1+pert)*real(nom(1)):dev:2*dev];
        for m=1:length(rpart)
            erm(m)=transpose(resid(rpart(m)))*resid(rpart(m));
        end
        [erroval,index1]=min(erm);
        bftp1=rpart(index1);
        pguess=[bftp1];
    end
end

%Here is the STS-1 t5/b5 pole solver
if(length(nom)==4)
     rpart=[(1+pert)*real(nom(1)):dev:0];
     ipart=[(1+pert)*imag(nom(1)):dev:0];
     p2=[(1+pert)*real(nom(2)):dev:0];
     p3=[(1+pert)*real(nom(3)):dev:0];
     p4=[(1+pert)*real(nom(4)):dev:0];
     rpart=[rpart real(nom(1))];
     ipart=[ipart imag(nom(1))];
     p2=[p2 real(nom(2))];
     p3=[p3 real(nom(3))];
     p4=[p4 real(nom(4))];

for m=1:length(rpart)
    for n=1:length(ipart)
        for l=1:length(p2)
            for q=1:length(p3)
                for r=1:length(p4)
                pertval=[rpart(m)+i*ipart(n); p2(l); p3(q); p4(r)];    
                erm(m,n,l,q,r)=transpose(resid(pertval))*resid(pertval);
                end
            end
        end
    end
end

[erroval,index5]=min(min(min(min(min(erm)))));
[erroval,index4]=min(min(min(min(erm(:,:,:,:,index5)))));
[erroval,index3]=min(min(min(erm(:,:,:,index4,index5))));
[erroval,index2]=min(min(erm(:,:,index3,index4,index5)));
[erroval,index1]=min(erm(:,index2,index3,index4,index5));


bftp1=rpart(index1)+i*ipart(index2);

pguess=[bftp1; p2(index3); p3(index4); p4(index5)];
 
end


if(length(pguess)==0)
    'Error in priorsol'
end














end

