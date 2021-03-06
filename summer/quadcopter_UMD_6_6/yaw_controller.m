function yaw_controller(src,imu_msg,handles)
disp('yaw controller running');
% disp(imu_msg.Data);
w = imu_msg.Orientation.W;
x = imu_msg.Orientation.X;
y = imu_msg.Orientation.Y;
z = imu_msg.Orientation.Z;
% [cur_yaw, cur_pitch, cur_roll] = quat2angle([x y z w]);
euler = quat2eul([w x y z]);
cur_yaw = euler(1);
cur_pitch = euler(2);
cur_roll = euler(3);
cur_yaw = rad2deg(cur_yaw);
cur_pitch = rad2deg(cur_pitch);
cur_roll = rad2deg(cur_roll);

persistent t0 yaw_offset ; 
tlag = 20;
if isempty(yaw_offset), yaw_offset = cur_yaw; end
cur_yaw = cur_yaw - yaw_offset;

%% make plots 
% figure(1);
% subplot(3,1,1); set(gca,'ylim',[-180 180]);
% hold on, ylabel('Yaw '); grid on;
%     
% subplot(3,1,2); set(gca,'ylim',[-360 360]);
% hold on, ylabel('pitch'); grid on;
%     
% subplot(3,1,3); set(gca,'ylim',[-360 360]);
% hold on, ylabel('roll'); grid on;
%     
% abs_t = eval([int2str(imu_msg.Header.Stamp.Sec) '.' ...
% int2str(imu_msg.Header.Stamp.Nsec)]);
% if isempty(t0), t0 = abs_t; end
% t = abs_t-t0;
% 
% subplot(3,1,1)
% plot(t,(cur_yaw),'r.'); set(gca,'xlim',[max(t-tlag,0) max(t,1)])
%     
% subplot(3,1,2)
% plot(t,(cur_pitch),'r.'); set(gca,'xlim',[max(t-tlag,0) max(t,1)])
%     
% subplot(3,1,3)
% plot(t,(cur_roll),'r.'); set(gca,'xlim',[max(t-tlag,0) max(t,1)])

%% get si_des and k_si from user
gain = str2double(get(handles.k_si_editTextBox,'String'));
des_yaw = str2double(get(handles.si_des_editTextBox,'String'));

%display current yaw in gui
set(handles.si_a_editTextBox,'String',num2str(cur_yaw));
    
%get yaw error
yaw_error = deg2rad((des_yaw - cur_yaw));
yaw_error  = (atan2(sin(yaw_error),cos(yaw_error)));

u_stick_cmd(1:4) = inf;
u_stick_cmd(4) = gain*yaw_error;
u_stick_cmd(4) = max(-1,min(1,u_stick_cmd(4)));
trim_scaled(1:4) = inf;
textDispVec = [handles.thrustDisplay handles.rollDisplay...
               handles.pitchDisplay handles.yawDisplay]; 
send_stick_cmd(u_stick_cmd,trim_scaled,...
handles.sTrainerBox,handles.stick_lim,handles.pax,textDispVec);
    
 