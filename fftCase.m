%%%fft of case data
clear;
clc;
path='/home/gurkan/Desktop/mlann/CWRU/48DriveEndFault/';
save_path='/home/gurkan/Desktop/mlann/matlabfilesenvelopeanalysis';
folders=dir(strcat(path,'1*'));
fft_length=32768;
sliding_distance=10000;
env_mat=[];
labels=[];
settings=[];
severity=[];
record_id=[];
dummy_int=1;
for folder_id=1:length(folders)
    files=dir(strcat(path,folders(folder_id).name,'/*.mat'));
    for file_id=1:length(files)
        dummy=load(strcat(path,folders(folder_id).name,'/',files(file_id).name),'*DE_time');
        names=fieldnames(dummy);
        save_id=names{1};
        data=getfield(dummy,save_id);       
        for i=0:(length(data)-fft_length)/sliding_distance-1
            frame=data(i*sliding_distance+1:i*sliding_distance+fft_length);
            [env,dty] = envelope1(frame,1/48000,8,2000,6000);
            L=length(env);
            Y=fft(env);
            P2=abs(Y/L);
            P1=P2(1:L/2+1);
            P1(2:end-1)=2*P1(2:end-1);
            f=(0:L/2)*(1/dty)/(L);
            env_mat=[env_mat,P1];
            record_id=[record_id,dummy_int];
            if contains(files(file_id).name,'0.007')
                severity=[severity,7];
            elseif contains(files(file_id).name,'0.014')
                severity=[severity,14];
            elseif contains(files(file_id).name,'0.021')
                severity=[severity,21];
            else
                severity=[severity,0];
            end
            if contains(files(file_id).name,'Normal')
                labels=[labels,1];
            elseif contains(files(file_id).name,'Inner')
                labels=[labels,2];
            elseif contains(files(file_id).name,'Outer')
                labels=[labels,3];
            else
                labels=[labels,4];
            end
            if folders(folder_id).name=='1730'
                settings=[settings,1730];                
            elseif folders(folder_id).name=='1750'
                settings=[settings,1750];
            elseif folders(folder_id).name=='1772'
                settings=[settings,1772];
            elseif folders(folder_id).name=='1797'
                settings=[settings,1797];
            end
        end
        dummy_int=dummy_int+1;
    end
end