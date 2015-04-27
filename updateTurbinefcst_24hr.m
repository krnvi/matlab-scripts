

function [newpowFcst1 newpowFcst2] = updateTurbinefcst_24hr(DT,Ti)
%clc; clear all ; close all ;

  model='/home/OldData/AnaikadavuSetupAndData/powerModelOutput/00gmt/' ;
  %model='/home/OldData/windpowerFcst/NMMV3.2.1/outFiles/Anaikadavu/' ;
  obs='/home/OldData/windpowerFcst/NMMV3.2.1/realtimeData/turbineData/' ;
  fcstpath='/home/OldData/windpowerFcst/reggMethods/linearReg/24hrfcst/' ;
  ssFcstpath='/home/OldData/windpowerFcst/reggMethods/smoothSpline/24hrfcst/' ;
  sosFcstpath='/home/OldData/windpowerFcst/reggMethods/sumofsine/24hrfcst/' ;
  
 % DT='20131226' ; Ti='24'
  
  fcstStdt=datenum([DT(1:4) '/' DT(5:6) '/' DT(7:8) ' ' Ti ':00']) ;
  fcstEtdt=addtodate(fcstStdt,24,'hour') ; nxDt=datestr(fcstStdt,'yyyymmdd') ;
  
  %fcstStdt=addtodate(fcdt,01,'hour') ;
  
fileName=['TATAK52';'NSLAK12';'TATAK63';'ATCAK01';'NPRAK09';'NPRAK12';'PTPPP01';'NPRAK10';'NPRAK07';'NPRAK11';'NPRAK08';'NPRAK13';'GALAK09';'GALAK08';...
          'GALAK04';'GALAK16';'TATAK10';'TATAK11';'TATAK13';'TATAK22';'TATAK41';'TATAK45';'TATAK56';'TATAK07';'TATAK28';....
          'TATAK30';'TATAK44';'TATAK23';'TATAK06';'TATAK12';'TATAK31';'TATAK15';'TATAK32';'TATAK51';'TATAK63';'TATAK33';....
          'TATAK24';'TATAK49';'TATAK50';'TATAK47';'TATAK61';'TATAK52';'TATAK53';'TATAK17';'TATAK42';'TATAK38';'TATAK59';'TATAK25';....
          'TATAK46';'TATAK36';'TATAK39';'TATAK55';'TATAK60';'TATAK14';'TATAK19';'TATAK16';'TATAK27';'TATAK02';'TATAK40';'TATAK37';....
          'TATAK21';'TATAK08';'TATAK54';'TATAK48';'TATAK57';'TATAK26';'TATAK43';'TATAK20';'TATAK35';'TATAK18';'TATAK29';'TATAK01';.....	
          'TATAK09';'TATAK05';'TATAK62';'TATAK64';'TATAK58';'TATAK03';'TATAK34';'TATAK65';'TATAK66';'TATAK04';'GALAK01';'GALAK17';.... 
          'GALAK15';'GALAK02';'GALAK14';'GALAK13';'GALAK12';'GALAK06';'GALAK05';'GALAK03';'GALAK10';'GALAK11';'GALAK07';....      
'NSLAK01';'NSLAK04';'NSLAK15';'NSLAK03';'NSLAK05';'NSLAK02';'NSLAK10';'NSLAK09';'NSLAK06';'NSLAK16';'NSLAK08';'NSLAK14';
'NSLAK12';'NSLAK13';'NSLAK17';'NSLAK27';'NSLAK11';'NSLAK07';'NSLAK26';'NSLAK20';'NSLAK31';'NSLAK32';'NSLAK29';'NSLAK23';'NSLAK18';
'NSLAK24';'NSLAK21';'NSLAK19';'NSLAK28';'NSLAK30';'NSLAK25';'NSLAK22';'RSMAK02';'RSMAK01';'SDSAK01';'ITCAK01';'ITCAK05';
'ITCAK03';'ITCAK04';'ITCAK02';'NSLAK33';'ATCAK01'];

        
 for fl=1:length(fileName)
     
      %Assigning filename and path
      %mFle=[model,DT,'00/',fileName(fl,1:end),'_',DT,'00.csv'] ;
      mFle=[model,DT,'00/',fileName(fl,1:end),'-',DT,'00.csv'] ;
      mFle2=[model,nxDt,'00/',fileName(fl,1:end-2),'-',fileName(fl,end-1:end),'-',nxDt,'00.csv'] ;
      oFle=[obs,DT,'/','locsData/',fileName(fl,1:end-2),'-',fileName(fl,end-1:end),'-',DT,'.csv'] ; 
      
      fcstFil=[fcstpath,DT,'/',Ti,'/',fileName(fl,:),'_',DT,'_',Ti,'00.csv'] ;
      ssFcstfil=[ssFcstpath,DT,'/',Ti,'/',fileName(fl,:),'_',DT,'_',Ti,'00.csv'] ;
      sosFcstfil=[sosFcstpath,DT,'/',Ti,'/',fileName(fl,:),'_',DT,'_',Ti,'00.csv'] ;
      header={'Date,Time' 'PowerFcst'} ;
            
      s1=exist(oFle,'file') ; s2=exist(mFle,'file') ;
      
      if ( s1 == 2 )               %checking both obs and fcst files exist or not. if obs file doesn't exist,copies model fcst.
          disp('obs File exist') ;           %if model fcst not available, some other method has to be used. :Future work.   
            
      [cmpData remmodDat]=compile_data(mFle,oFle,fcstStdt,fcstEtdt) ;    %calling another Fn for arranging data.
                
      %Iz=find(cmpData(:,3)) ; cmpDat=cmpData(I,:) ;
      Tstat=gt(cmpData(:,3),0) ; cmpDat=cmpData(Tstat,:) ;   % if turbine status is zero for 6 hr block then copies model fcst.
                                                             % it should be changed later. :Future work 
       if (isempty(cmpDat))                                             
        [modFcst]=copymodel_Fcst(mFle,fcstStdt,fcstEtdt) ;             
        modfcTime=cellstr(datestr(modFcst(:,1),'yyyy/mm/dd,HH:MM')) ; 
        finalmodFcst=[header;[modfcTime num2cell(modFcst(:,4))]] ; 
        cell2csv(ssFcstfil,finalmodFcst,',') ;
        cell2csv(fcstFil,finalmodFcst,',') ;
        cell2csv(sosFcstfil,finalmodFcst,',') ;
        %continue  %quit force ;  
       else
       x=cmpDat(:,2) ; pow1=cmpDat(:,6) ;pow2=cmpDat(:,7) ;
       Ip1=le(pow1,0) ; rndNo1=rand(size(Ip1));  pow1(Ip1)=rndNo1(Ip1); Ip2=le(pow2,0); rndNo2=rand(size(Ip1)) ;pow2(Ip2)=rndNo2(Ip2);
       
       remPow1=remmodDat(:,4) ; remPow2=remmodDat(:,5) ; remTim=cellstr(datestr(remmodDat(:,1),'yyyy/mm/dd,HH:MM')) ;  
       %Ip1=le(remPow1,0) ;remPow1(Ip1)=50; Ip2=le(remPow2,0)
       %;remPow2(Ip2)=50;                                        %if modelfcst is less than zero 
                                                                 %it should be set to some default value. :future work 
       %%%%%%%%%%%LinearRegressin%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
       
       [slp1 int1] = linearFit(pow1,x) ;         
       [slp2 int2] = linearFit(pow2,x) ;
       
       SLP1(fl,1:2)=slp1 ;
       SLP2(fl,1:2)=slp2 ;
       
       
       newpowFcst1=(slp1(1,1)*remPow1)+(slp1(1,2)) ;
       newpowFcst2=(slp2(1,1)*remPow2)+(slp2(1,2)) ;   
       If=lt(newpowFcst1,0) ; newpowFcst1(If)=remPow1(If) ;
       If=lt(newpowFcst2,0) ; newpowFcst2(If)=remPow2(If) ;
       %Fcst=[remTim num2cell([newpowFcst1 newpowFcst2])] ;  
       Fcst=[remTim num2cell(newpowFcst1)] ;
       finalFcst=[header;Fcst]   ;              
       cell2csv(fcstFil,finalFcst,',') ;
       
       %%%%%%%%%%%%%%%%%%%%%%%%SmoothSpline%%%%%%%%%%%%%%%%%%%
       kz=size(cmpDat) ; 
       if ( kz(1,1) < 2 )
           [modFcst]=copymodel_Fcst(mFle,fcstStdt,fcstEtdt) ;             
            modfcTime=cellstr(datestr(modFcst(:,1),'yyyy/mm/dd,HH:MM')) ; 
            finalmodFcst=[header;[modfcTime num2cell(modFcst(:,4))]] ; 
            cell2csv(ssFcstfil,finalmodFcst,',') ;
            %quit force ; 
       else
       ssf1=smoothSplinefit(pow1,x);
       %ssf2=smoothSplinefit(pow2,x);
       powFcstssf1=ssf1(remPow1) ; %powFcstssf2=ssf2(remPow2) ;
       
       Imin=lt(powFcstssf1,0) ; powFcstssf1(Imin)=0 ; clear Imin  %if the forecast is less than zero , then it is set to zero.
       %Imin=lt(powFcstssf2,0) ; powFcstssf2(Imin)=0 ; clear Imin         
       
       Imax=find(gt(powFcstssf1,950)) ; 
       if (~isempty(Imax)) ;
           
           Iobs=find(gt(x,950)) ; 
           if (isempty(Iobs))
               kk=lt(powFcstssf1,950) ; mnpow1=(mean(powFcstssf1(kk))+std(powFcstssf1(kk)));
               powFcstssf1(Imax)=mnpow1; clear Iobs ; powFcstssf11=powFcstssf1 ;
                            
           else 
               kk=gt(powFcstssf1,1500) ; powFcstssf1(kk)=1300;
               clear kk ; powFcstssf11=powFcstssf1 ;           
           end
           
           
       else
           powFcstssf11=powFcstssf1 ; clear Imax ;  
           %continue ;
           
       end
       
       
       %powFcstssf1(Imax)=remPow1(Imax);  clear Imax  %if the forecast is greater than 950 , then it is set to model fcst.
       % Imax=gt(powFcstssf2,950) ; powFcstssf2(Imax)=remPow2(Imax) ; clear Imax  % betz limit, :future work
       
       
       %finalFcstssf=[header;[remTim num2cell([powFcstssf1 powFcstssf2])]] ;
       finalFcstssf=[header;[remTim num2cell(powFcstssf11)]] ;
       cell2csv(ssFcstfil,finalFcstssf,',') ;
       end
       %%%%%%%%%%%%%%%%%%%%%%%% Sum of Sine %%%%%%%%%%%%%%%%%%%
       if (length(x) < 18 )                                             
        [modFcst]=copymodel_Fcst(mFle,fcstStdt,fcstEtdt) ;             
        modfcTime=cellstr(datestr(modFcst(:,1),'yyyy/mm/dd,HH:MM')) ; 
        finalmodFcst=[header;[modfcTime num2cell(modFcst(:,4))]] ; 
        cell2csv(sosFcstfil,finalmodFcst,',') ;
        continue  %quit force ;                                                                                   
       end                         
              
       sos1=sumofsineFit(pow1,x) ; powFcstsos1=sos1(remPow1) ;
       Imin=lt(powFcstsos1,0) ; powFcstsos1(Imin)=0 ; clear Imin ;
       
       Imax=find(gt(powFcstsos1,950)) ; 
       if (~isempty(Imax)) ;
           
           Iobs=find(gt(x,950)) ; 
           if (isempty(Iobs))
               kk=lt(powFcstssf1,950) ; mnpow1=(mean(powFcstssf1(kk))+std(powFcstssf1(kk)));
               powFcstsos1(Imax)=mnpow1;  clear Iobs ; powFcstsos11=powFcstsos1 ;
                            
           else 
               kk=gt(powFcstsos1,1500) ; powFcstsos1(kk)=1300; 
                clear kk ; powFcstsos11=powFcstsos1 ;         
           end
           
           
       else
           powFcstsos11=powFcstsos1 ;
           clear Imax ; %continue ;
           
           
       end
       
       finalFcstsos=[header;[remTim num2cell(powFcstsos11)]] ;
       cell2csv(sosFcstfil,finalFcstsos,',') ;
               
       
       
       clear slp1 ; clear slp2; clear newpowFcst1; clear newpowFcst2 ; clear cmpDat ; clear pow1 ; clear pow2; clear x;
       clear cmpData ; clear remPow1 ; clear remPow2 ; clear remTim ; clear remmodDat ; clear Fcst ;
       end 
       else                                   
          disp('fcst / obs file does not exist ... Copy Model Fcst') ;
          [modFcst]=copymodel_Fcst(mFle,fcstStdt,fcstEtdt) ;
          modfcTime=cellstr(datestr(modFcst(:,1),'yyyy/mm/dd,HH:MM')) ; 
          finalmodFcst=[header;[modfcTime num2cell(modFcst(:,4))]] ;
          cell2csv(ssFcstfil,finalmodFcst,',') ;
          cell2csv(fcstFil,finalmodFcst,',') ;
          cell2csv(sosFcstfil,finalmodFcst,',') ;
          %continue %quit force ;
      end 
 end
end

  