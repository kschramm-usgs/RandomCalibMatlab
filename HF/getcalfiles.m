function [bhdataname,bcdataname,sensor] = getcalfiles(caldriverfile)
    %This is the file to find all of the various cals files and their
    %sensors
    



    %read in all of the calibrations we are going to do
    fid=fopen(caldriverfile);
    output=textscan(fid,'%s %s %s');
    fclose(fid);

    numberofcals=length(output{:,1});
    bhdataname=output{1,1};
    bcdataname=output{1,2};
    sensor=output{1,3};




end

