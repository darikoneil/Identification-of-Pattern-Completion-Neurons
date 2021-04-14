
%LOAD DIRECTORY
mod_dir = uigetdir(pwd,'SELECT_MODEL_DIRECTORY');
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

DTPS = zeros(600,810);
for i = 1:10
    A = 1+(60*(i-1));
    B = 60+(60*(i-1));
    C = 1+(81*(i-1));
    D=81+(81*(i-1));
    DTPS(A:B,C:D)=MATRICES.ST{i};
    RIGHT = zeros(60,((10-i)/9)*729);
    LEFT = zeros(60,((i-1)/9)*729);
    for a = 1:60
        for b=1:length(RIGHT)
        x=rand;
            if x>0.9762
            RIGHT(a,b)=1;
            end
        end
    end
    for a=1:60
        for b=1:length(LEFT)
            x=rand;
            if x>0.9762
                LEFT(a,b)=1;
            end
        end
    end
    
    DTPS(A:B,(D+1):end)=RIGHT;
    DTPS(A:B,1:(C-1))=LEFT;
end
DTPS(DTPS<0)=0;
data = DTPS;

DTPS  = [DTPS zeros(600,100)];
for i = 1:10
    A = 1+(60*(i-1));
    B = 60+(60*(i-1)); 
    C = 1+(10*(i-1))+810;
    D=10+(10*(i-1))+810;
    DTPS(A:B,C:D)=MATRICES.ENS{i};
end
DTPS(DTPS<0)=0;
UDF = DTPS;

coords = randi(512,810,2);
coords = [coords randi(150,810,1)];

for i = 1:10
     A = 1+(81*(i-1));
     B = 81+(81*(i-1)); 
     coords(A:B,3)=(i*50);
end

save('SIM_DATA.mat')
