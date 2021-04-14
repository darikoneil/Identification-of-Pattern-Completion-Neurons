
cd thirdparty
cd QPBO-v1.32.src

fileID = fopen('Makefile','r');
mydata=cell(1,40);

for i = 1:40
    mydata{i}=fgetl(fileID);
end
mydata{19}=strcat('MEX=',matlabroot,'/bin/mex');
fclose(fileID);

fileID = fopen('Makefile','w');
fprintf(fileID,'%s\n',mydata{:});
fclose(fileID);



