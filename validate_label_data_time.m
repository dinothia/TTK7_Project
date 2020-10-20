clear all
path = '/home/torbjorn/Documents/TTK7_Project/Data/';

%trondheim or vanvikan
quay = "trondheim";
qyay = "vanvikan";

day = 1;
trip = 1;

dataset_nr = 1;


unlabeled_path = strcat(path,quay,'/imu_measurements_',num2str(day),'_',num2str(trip));
labeled_path = strcat(path,'labeled_data/data',num2str(dataset_nr));

load(unlabeled_path)
load(labeled_path);

figure(1);clf

for dataset_nr=1:8
    dataset_nr
    day = fix((dataset_nr-1)/4)+1;
    trip = rem(dataset_nr-1,4)+1;


    unlabeled_path = strcat(path,quay,'/imu_measurements_',num2str(day),'_',num2str(trip));
    labeled_path = strcat(path,'labeled_data/data',num2str(dataset_nr));

    load(unlabeled_path);
    load(labeled_path);
    
    imuData.colition_label = imu_mat(8,:);
    imuData.speed = imu_mat(7,:);  
    
    clf;
    plot(imuData.ang_velocity(3,:))
    hold on
    plot(imu_mat(6,:))
    pause(1)
    
    
end