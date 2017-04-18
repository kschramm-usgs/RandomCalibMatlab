This code estimates the mid-band and long-period corners for broadband instruments by way of random calibration data.

To run this code place your BH* output data and your BC input data into the directory.  Place the names of the files in the caldriver.txt file.
On the same line also place the instrument you would like to fit your data with.  The following are possible:
STS-1
STS-1t5
KS-54000
STS-2
CMG-3T
TR-240

Then run the script GSNPOLEZERO.m results will be put into a directory.  

You can also add other instruments by making additional changes to the various files.