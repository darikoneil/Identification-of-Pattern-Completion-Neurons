%LOAD DIRECTORY
%mod_dir = uigetdir(pwd,'SELECT_MODEL_DIRECTORY');
mod_dir = fullfile(basepath,'Small_Network');
Files = dir(fullfile(mod_dir, '*.hdf5'));

MATRICES = struct;
MATRICES.ST=[];
MATRICES.ENS =[];

%ST is the states 
%ENS is the ensembles

%Load split model files into a matrix of the ensembles and states
for i = 1:length(Files)
    FILENAME = strcat(Files(i).folder, '/', Files(i).name);
    STATE_TEMP = h5read(FILENAME,'/STATE_TEMP');
    [ST,ENS] = convert_state_temp_to_ST_and_ENS(STATE_TEMP);
    MATRICES.ST{end+1}=ST;
    MATRICES.ENS{end+1}=ENS;
end

%NOW THAT WE HAVE RETRIEVED THE STATES AND ENSEMBLES
%WE MAKE INTO LARGE MATRIX WHERE HOPFIELD ARE 60x81 DIAGONALS

DTPS = zeros(60,81);
for i = 1
    A = 1+(60*(i-1));
    B = 60+(60*(i-1));
    C = 1+(81*(i-1));
    D=81+(81*(i-1));
    DTPS(A:B,C:D)=MATRICES.ST{i};
end
DTPS(DTPS<0)=0;
data = DTPS;

UDF = MATRICES.ENS{1};
UDF(UDF<0)=0;


coords = randi(512,81,2);
coords = [coords randi(150,81,1)];


clearvars -except data UDF coords;
filename = 'SIM_DATA.mat';

save(filename);
clear all