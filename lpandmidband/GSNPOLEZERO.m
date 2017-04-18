%This program computes the instrument response of an instrument using a
%random calibration signal
%Version number
ver=1;
%Calibration file name
calfilename='caldriver.txt';
%Here is an index for the number of bad calibrations
ind=1;
fid=fopen(calfilename);
%read in all of the calibrations we are going to do
output=textscan(fid,'%s %s %s');
fclose(fid);
bhchannel=output{:,1};
bcchannel=output{:,2};
sensorall=output{:,3};
numberofcals=length(sensorall(:,1));
for jj=1:numberofcals
    bhchanneltemp=char(bhchannel(jj,:));
    bcchanneltemp=char(bcchannel(jj,:));
    %Loop through each calibration and get the various information needed 
    [bhdata,bhdataI]=rdmseed(bhchanneltemp);
    [bcdata,bcdataI]=rdmseed(bcchanneltemp);
    networktemp=deblank(bhdata(1,1).NetworkCode);
    stationtemp=deblank(bhdata(1,1).StationIdentifierCode);
    locationtemp=deblank(bhdata(1,1).LocationIdentifier);
    channeltemp=deblank(bhdata(1,1).ChannelIdentifier);
    sampleratetemp=bhdata(1,1).SampleRate;
    yeartemp=bhdata(1,1).RecordStartTimeISO;
    yeartemp=yeartemp(1:8);
    daytemp=yeartemp(6:8);
    yeartemp=yeartemp(1:4);
    sensortemp=deblank(char(sensorall(jj,:)));
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
    input=bcdatafinal;
    output=bhdatafinal;
    clear bhdata bcdata bcdatafinal bhdatafinal bhdatatemp ...
         bcdatatemp bhdatatimetemp bcdatatimetemp bhdatatimeall bcdatatimeall
    try
        %Make a directory to put the results into
        mkdir([yeartemp '_' daytemp '_' networktemp '_' stationtemp]);
        [bftp1,nom,amperror,phaserror,perrors,phasernom, ...
            ampernom]=pzfit(networktemp,stationtemp,channeltemp, ...
            locationtemp,yeartemp,daytemp,sensortemp,sampleratetemp,output,input);
        filename=['ZP_' networktemp '_' stationtemp '_' locationtemp '_' channeltemp '_' sensortemp '_' yeartemp daytemp];
        filename = strrep(filename,'-','');
        [wrgood]=writeresp(filename,sensortemp,nom,bftp1,yeartemp, ...
            networktemp,stationtemp,locationtemp,channeltemp, ...
            daytemp,amperror,phaserror,perrors,phasernom,ampernom,ver);
    catch
        badcal(ind)=jj;
        ind=ind+1;
    end
end
fclose('all');