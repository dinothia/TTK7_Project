function [imu_data] = get_imu_data(bag,topic)
%% This function extract 6DOF-imu data from rosbag. The default imu topic is: /sentiboard/adis


%% Handle default topic for backward compatebility
if nargin<2
    topicName = '/sentiboard/adis';
else
    topicName = topic;
end

%% Read specific topic from Rosbag
bagselect_imu = select(bag,'Topic',topicName);
struct_imu = readMessages(bagselect_imu, 'DataFormat', 'struct');

% Store all messages in struct
temp_struct_imu = [struct_imu{:}];

% Identify start time. Sec = Unix time. nSec = nano second within unix second
t_imu_sec_start = double([temp_struct_imu(1).Header.Stamp.Sec]);
t_imu_Nsec_start = double([temp_struct_imu(1).Header.Stamp.Nsec]);
t_imu_start = (t_imu_sec_start+t_imu_Nsec_start*1e-9);

% Go through message list and extract information
for k = 1 : length(struct_imu)
    t_imu_sec(1,k) = double([temp_struct_imu(k).Header.Stamp.Sec]);
    t_imu_Nsec(1,k) = double([temp_struct_imu(k).Header.Stamp.Nsec]);

    %     t_imu(1,k) = (t_imu_sec(1,k) + t_imu_Nsec(1,k)*1e-9) - t_imu_start;
    t_imu(1,k) = (t_imu_sec(1,k) + t_imu_Nsec(1,k)*1e-9);
    
    %linear accelerations (accelerometer)
    imu_aX(1,k) = double([temp_struct_imu(k).LinearAcceleration.X]);
    imu_aY(1,k) = double([temp_struct_imu(k).LinearAcceleration.Y]);
    imu_aZ(1,k) = double([temp_struct_imu(k).LinearAcceleration.Z]);
    %angular velocity (gyro)
    imu_p(1,k) = double([temp_struct_imu(k).AngularVelocity.X]);
    imu_q(1,k) = double([temp_struct_imu(k).AngularVelocity.Y]);
    imu_r(1,k) = double([temp_struct_imu(k).AngularVelocity.Z]);
end

acceleration = [imu_aX; imu_aY; imu_aZ];
ang_velocity = [imu_p; imu_q; imu_r];

imu_data.acceleration = acceleration;
imu_data.ang_velocity = ang_velocity;
imu_data.t_imu = t_imu;
imu_data.t_imu_sec_raw = t_imu_sec;
imu_data.t_imu_Nsec_raw = t_imu_Nsec;

end
