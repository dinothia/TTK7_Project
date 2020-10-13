%% Locate ros bag

path = '/home/torbjorn/Documents/Autodocking/Data/';
%Folder containing the spesific data file
days = ["Trondheimsfjord_23_06/","Trondheimsfjord_25_06/"];
dates = ["2020_06_23","2020_06_25"];
%trondheim or vanvikan
quay = "vanvikan";
%quay = "trondheim";
%Which trip shoulld be read

% 
day = 1;
trip = 2;

time = quay+num2str(trip)+"_inn";
bagName = quay+num2str(trip)+"_inn.bag";
bag = rosbag(path+days(day)+bagName);

%% Show camera and imu plot
get_camera_and_imu(bag)