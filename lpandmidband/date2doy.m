function doy = date2doy(month,day,year)
%Convert from month day and year to day of year
    if(mod(year,4)==0)
        dayspermonth = [31 29 31 30 31 30 31 31 30 31 30 31];
        if(mod(year,100)==0)
            dayspermonth = [31 28 31 30 31 30 31 31 30 31 30 31];
            if(mod(year,400)==0)
                dayspermonth = [31 29 31 30 31 30 31 31 30 31 30 31];
            end
        end
    else
        dayspermonth = [31 28 31 30 31 30 31 31 30 31 30 31];
    end
doy = sum(dayspermonth(1:month-1))+day;
