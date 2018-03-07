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
for folder_id=1:length(folders)
    files=dir(strcat(path,folders(folder_id).name,'/*.mat'));
    for file_id=1:length(files)
        dummy=load(strcat(path,folders(folder_id).name,'/',files(file_id).name),'*DE_time');
        names=fieldnames(dummy);
        save_id=names{1};
        data=getfield(dummy,save_id);        
        for i=0:(length(data)-fft_length)/sliding_distance-1
            frame=data(i*sliding_distance+1:i*sliding_distance+fft_length);
            [env,dty] = envelope2(frame,1/48000,2000,6000);
            L=length(env);
            Y=fft(env);
            P2=abs(Y/L);
            P1=P2(1:L/2+1);
            P1(2:end-1)=2*P1(2:end-1);
            f=(0:L/2)*(1/dty)/(L);
            if 1
                env_mat=[env_mat,P1];
                if contains(files(file_id).name,'Inner')
                    labels=[labels,1];
                elseif contains(files(file_id).name,'Outer')
                    labels=[labels,2];
                elseif contains(files(file_id).name,'Ball')
                    labels=[labels,3];
                else
                    labels=[labels,4];
                end
            end
        end
    end
end