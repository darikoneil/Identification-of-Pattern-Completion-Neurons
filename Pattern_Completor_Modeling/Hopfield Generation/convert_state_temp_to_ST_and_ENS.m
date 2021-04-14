function [ST,ENS] = convert_state_temp_to_ST_and_ENS(STATE_TEMP)
S1 = size(STATE_TEMP,1);
S2 = size(STATE_TEMP,2);
S3 = size(STATE_TEMP,3);

ST=[];

for i = 1:S3
    ST = [ST;transpose(STATE_TEMP(:,:,i))];
end

ENS = zeros(S2*S3,S3);

ENS(1:6,1)=1;

for i = 2:S3
    A = (((i-1)*6)+1);
    B = (i*6);
    ENS(A:B,i)=1;
end


end
