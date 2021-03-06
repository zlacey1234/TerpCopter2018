function kpcb(src,evnt,handles,textDispVec)
% ListenChar(2); % disables printing char to screen
% disp(src)
% disp(evnt)
disp('key pressed');   
keypressed = evnt.Key;
switch( keypressed)
           case {'W','w'}
               % update marker pos
               cp1 =[handles.pax(1).XData, (handles.pax(1).YData+(8/147)) ];
               cp2 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'S','s'}
               % update marker pos
               cp1 =[handles.pax(1).XData, (handles.pax(1).YData-(8/147)) ];
               cp2 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'D','d'}
               % update marker pos
               % if stick is on left, bring to center
               if handles.pax(1).XData<0
                  cp1 = [0, handles.pax(1).YData];
               else
                  cp1 =[(handles.pax(1).XData+(8/147)), handles.pax(1).YData ];
               end
               cp2 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'A','a'}
               % update marker pos
               % if stick is on left, bring to center
               if handles.pax(1).XData>0
                  cp1 = [0, handles.pax(1).YData];
               else
                  cp1 =[(handles.pax(1).XData-(8/147)), handles.pax(1).YData ];
               end
               cp2 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'Z','z'}
               % update marker pos
               cp1 =[0, handles.pax(1).YData ];
               cp2 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'uparrow'}
               % update marker pos
               % if stick is on left, bring to center
               if handles.pax(2).YData<0
                  cp2 = [handles.pax(2).XData,0];
               else
                  cp2 =[handles.pax(2).XData,(handles.pax(2).YData+((10/147))) ];
               end
               cp1 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
           
           case {'downarrow'}
               % update marker pos
               if handles.pax(2).YData>0
                  cp2 = [handles.pax(2).XData,0];
               else
                  cp2 =[handles.pax(2).XData,(handles.pax(2).YData-(10/147)) ];
               end
               cp1 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'rightarrow'}
               % update marker pos
               if handles.pax(2).XData<0
                  cp2 = [0,handles.pax(2).YData];
               else
                  cp2 =[(handles.pax(2).XData+(10/147)),handles.pax(2).YData ];
               end
               cp1 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
               
           case {'leftarrow'}
               % update marker pos
               if handles.pax(2).XData>0
                  cp2 = [0,handles.pax(2).YData];
               else
               cp2 =[(handles.pax(2).XData-((10/147))),handles.pax(2).YData ];
               end
               cp1 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
          
           case {'shift'}
               % update marker pos
               cp2 =[0, 0 ];
               cp1 = [inf,inf];
               wbmcb(handles.pax,cp1,cp2,handles.sTrainerBox);
end
               
           
      function wbmcb(pax,cp1,cp2,sTrainerBox)
          if cp1(1,1)~=inf, cp1(1,1)= max(-1,min(1,cp1(1,1)));end
          if cp1(1,2)~=inf, cp1(1,2)= max(-1,min(1,cp1(1,2)));end
          cp1
          cp2
          if cp2(1,1)~=inf, cp2(1,1)= max(-1,min(1,cp2(1,1)));end
          if cp2(1,2)~=inf, cp2(1,2)= max(-1,min(1,cp2(1,2)));end
          % get stick commands based on marker position
          % note: u_stick_cmd lies between [-1 1]
          u_stick_cmd(1) = cp1(1,2); 
          u_stick_cmd(2) = cp2(1,1);
          u_stick_cmd(3) = cp2(1,2);
          u_stick_cmd(4) = cp1(1,1);
          
          % set trim values to inf here, trim will be set by slider
          % callback
          trim_scaled(1:4) = inf;
          disp('calling send_stick_cmd()');
          send_stick_cmd(u_stick_cmd,trim_scaled,...
          sTrainerBox,handles.stick_lim,pax,textDispVec);
       
      end 
end