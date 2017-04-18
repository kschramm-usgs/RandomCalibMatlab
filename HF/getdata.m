function [bhdata, bcdata,info]=getdata(bhchannel,bcchannel)

    %Lets pull in the data and chop it around the random cal
    %In case we get cells
    bhchannel=char(bhchannel);
    bcchannel=char(bcchannel);
    

        
    %Read in the data
    [bhdata,~]=rdmseed(bhchannel);
    [bcdata,~]=rdmseed(bcchannel);
    info{1,1}=deblank(bhdata(1,1).NetworkCode);
    info{1,2}=deblank(bhdata(1,1).StationIdentifierCode);
    info{1,3}=deblank(bhdata(1,1).LocationIdentifier);
    info{1,4}=deblank(bhdata(1,1).ChannelIdentifier);
    info{1,5}=bhdata(1,1).SampleRate;
  
    year=bhdata(1,1).RecordStartTimeISO;
    year=year(1:8);
    day=year(6:8);
    year=year(1:4);
    info{1,6}=year;
    info{1,7}=day;
    

    %Lets fine the cal blockettes of type 320
    calblock=1;
    for checkcal=1:length(bhdata(1,:))
        if(~isempty(bhdata(1,checkcal).BLOCKETTE320))
            calstart(calblock)=bhdata(1,checkcal).BLOCKETTE320.RecordStartTimeMATLAB;
            caldur(calblock)=bhdata(1,checkcal).BLOCKETTE320.CalDuration;
            calblock=calblock+1;
        end
    end

    datestart=datevec(calstart);
    dateend=datestart;
    dateend(:,6)=dateend(:,6)+caldur'./10000;
    dateend=datenum(dateend);
    datestart=datenum(datestart);
    bhdataall=cat(1,bhdata.d);
    bhdatatimeall=cat(1,bhdata.t);
    bcdataall=cat(1,bcdata.d);
    bcdatatimeall=cat(1,bcdata.t);
    bhdatafinal=[];
    bcdatafinal=[];

    for checkcal=1:length(datestart(:,1))
        bhdatatemp=bhdataall(bhdatatimeall >= datestart(checkcal));
        bcdatatemp=bcdataall(bcdatatimeall >= datestart(checkcal));
        bhdatatimetemp=bhdatatimeall(bhdatatimeall >= datestart(checkcal));
        bcdatatimetemp=bcdatatimeall(bcdatatimeall >= datestart(checkcal));
        bhdatatemp=bhdatatemp(bhdatatimetemp <= dateend(checkcal));
        bcdatatemp=bcdatatemp(bcdatatimetemp <= dateend(checkcal));
        bcdatafinal=[bcdatafinal; bcdatatemp];
        bhdatafinal=[bhdatafinal; bhdatatemp];
    end
    bcdata=bcdatafinal;
    bhdata=bhdatafinal;

end
