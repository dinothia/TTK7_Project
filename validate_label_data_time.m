clear all
path = '/home/torbjorn/Documents/TTK7_Project/Data/';

%trondheim or vanvikan
%quay = "trondheim";
quay = "vanvikan";

day = 1;
trip = 2;

dataset_nr = 10;


unlabeled_path = strcat(path,quay,'/imu_measurements_',num2str(day),'_',num2str(trip));
labeled_path = strcat(path,'labeled_data/data',num2str(dataset_nr));

load(unlabeled_path)
load(labeled_path);

figure(1);clf
plot(imuData.ang_velocity(3,:))
hold on
plot(imu_mat(6,:))
pause(1)


dataset_idx = 9;
%%
for dataset_nr=9:15
    
    if dataset_idx == 13
        dataset_idx = dataset_idx+1;
    end
    day = fix((dataset_idx-1)/4)-1;
    trip = rem(dataset_idx-1,4)+1;


    unlabeled_path = strcat(path,quay,'/imu_measurements_',num2str(day),'_',num2str(trip));
    labeled_path = strcat(path,'labeled_data/data',num2str(dataset_nr));
    
        load(unlabeled_path);
        load(labeled_path);

        imuData.colition_label = imu_mat(8,:);
        imuData.speed = imu_mat(7,:);  
    %     
%         clf;
%         plot(imuData.ang_velocity(3,:))
%         hold on
%         plot(imu_mat(6,:))
%         pause(1)
%        
    
    
    save(strcat(path,quay,'/imu_measurements_',num2str(day),'_',num2str(trip)),'imuData')
    
    dataset_idx = dataset_idx+1;
end