function y=trot_traj(u)
%----����ʱ���źźͽӴ��źţ����㼫����ϵ�µ���˹켣�滮-----%
global T_strid Hip_Height trot_duty
persistent Q0_des
tim=u(1);
pitch=u(2);roll=u(3);roll_d=u(4);
roll_max=0.07;
% adjust_pitch=0*0.85*tan(pitch);
% adjust_roll=0*0.35*tan(roll);
% adjust_LF_Pz=-adjust_pitch+adjust_roll;
% adjust_RH_Pz=adjust_pitch-adjust_roll;
% adjust_RF_Pz=-adjust_pitch-adjust_roll;
% adjust_LH_Pz=adjust_pitch+adjust_roll;
% if adjust_Pz<-0.15 %�޷�
%     adjust_Pz=-0.15;
% end
if tim<=1.5        %��������ȶ�
    LF_P_car_des=[0;Hip_Height]; 
    LF_Pd_car_des=[0;0];
    [LF_P_polar_des,LF_Pd_polar_des]=carTopolar(LF_P_car_des,LF_Pd_car_des);
    RF_P_polar_des=LF_P_polar_des;RF_Pd_polar_des=LF_Pd_polar_des;
    RH_P_polar_des=LF_P_polar_des;RH_Pd_polar_des=LF_Pd_polar_des;
    LH_P_polar_des=LF_P_polar_des;LH_Pd_polar_des=LF_Pd_polar_des;
    Q0_des=[0;0;0;0;0;0;0;0];
elseif tim>1.5 && tim<2     %��ʼ�׶Σ������˶�ǰ��׼������
    RF_pha_sw=(tim-1.5)/0.5;
    [RF_P_car_des,RF_Pd_car_des]=Quad_Swing_traj_init(RF_pha_sw);
    LF_P_car_des=[0;Hip_Height];  LF_Pd_car_des=[0;0];  
    [LF_P_polar_des,LF_Pd_polar_des]=carTopolar(LF_P_car_des,LF_Pd_car_des);
    RH_P_polar_des=LF_P_polar_des;RH_Pd_polar_des=LF_Pd_polar_des;
    [RF_P_polar_des,RF_Pd_polar_des]=carTopolar(RF_P_car_des,RF_Pd_car_des);
    LH_P_polar_des=RF_P_polar_des;LH_Pd_polar_des=RF_Pd_polar_des;
    Q0_des=[0;0;0;0;0;0;0;0];
elseif tim>=2          %�����˶���ʼ
    t_residue=mod(2,T_strid);
    t_strid=mod((tim-t_residue+0.5*trot_duty*T_strid),T_strid);%����ǰ�Ⱥ��Һ��ȵ���λΪ�ο�
    pha=t_strid/T_strid;

    if pha>=0 && pha<trot_duty-0.5  %�����ȶ�վ��
        LF_pha_st=pha/trot_duty;
        [LF_P_car_des,LF_Pd_car_des]=Quad_Stance_traj(LF_pha_st);
        RH_P_car_des=LF_P_car_des;RH_Pd_car_des=LF_Pd_car_des;
         
        RF_pha_st=(pha+0.5)/trot_duty;
        [RF_P_car_des,RF_Pd_car_des]=Quad_Stance_traj(RF_pha_st);
        LH_P_car_des=RF_P_car_des;LH_Pd_car_des=RF_Pd_car_des;
    elseif pha>=trot_duty-0.5 && pha<0.5  %��ǰ�Ⱥ��Һ���վ�������������ڶ�
        LF_pha_st=pha/trot_duty;
        [LF_P_car_des,LF_Pd_car_des]=Quad_Stance_traj(LF_pha_st);
        RH_P_car_des=LF_P_car_des;RH_Pd_car_des=LF_Pd_car_des;
        
        RF_pha_sw=(pha-(trot_duty-0.5))/(1-trot_duty);
        [RF_P_car_des,RF_Pd_car_des]=Quad_Swing_traj(RF_pha_sw);
        LH_P_car_des=RF_P_car_des;LH_Pd_car_des=RF_Pd_car_des;
            %----�������ǿ���----
        if  roll>=roll_max %�Ҳ���
            RF_q0=-roll;%- roll - acos((1-0.35*tan(roll))/1);
            RF_qd0=-1*roll_d;%(- ((7*tan(roll)^2)/20 + 7/20)/(1 - ((7*tan(roll))/20 - 1)^2)^(1/2) - 1)*roll_d;
            RF_Q0=[RF_q0;RF_qd0];          
            LH_q0=-roll;LH_qd0=-1*roll_d;
            LH_Q0=[LH_q0;LH_qd0];
            Q0_des=[Q0_des(1);Q0_des(2);RF_Q0;Q0_des(5);Q0_des(6);LH_Q0];
        elseif roll<=-roll_max
            LH_q0=-roll;%- roll + acos((1+0.35*tan(roll))/1);
            LH_qd0=-roll_d;%(- ((7*tan(roll)^2)/20 + 7/20)/(1 - ((7*tan(roll))/20 + 1)^2)^(1/2) - 1)*roll_d;
            LH_Q0=[LH_q0;LH_qd0];
            RF_q0=-roll;RF_qd0=-1*roll_d;
            RF_Q0=[RF_q0;RF_qd0];
            Q0_des=[Q0_des(1);Q0_des(2);RF_Q0;Q0_des(5);Q0_des(6);LH_Q0];
        elseif roll>-roll_max && roll<roll_max
            Q0_des=[0;0;0;0;0;0;0;0];
        end
    elseif pha>=0.5 && pha<trot_duty  %�����ȶ�վ��
        LF_pha_st=pha/trot_duty;
        [LF_P_car_des,LF_Pd_car_des]=Quad_Stance_traj(LF_pha_st);
        RH_P_car_des=LF_P_car_des;RH_Pd_car_des=LF_Pd_car_des;
        
        RF_pha_st=(pha-0.5)/trot_duty;
        [RF_P_car_des,RF_Pd_car_des]=Quad_Stance_traj(RF_pha_st);
        LH_P_car_des=RF_P_car_des;LH_Pd_car_des=RF_Pd_car_des;
    elseif pha>=trot_duty && pha<=1  %��ǰ�Ⱥ��Һ��Ȱڶ�����������վ��
        LF_pha_sw=(pha-trot_duty)/(1-trot_duty);
        [LF_P_car_des,LF_Pd_car_des]=Quad_Swing_traj(LF_pha_sw);
        RH_P_car_des=LF_P_car_des;RH_Pd_car_des=LF_Pd_car_des;
        
        RF_pha_st=(pha-0.5)/trot_duty;
        [RF_P_car_des,RF_Pd_car_des]=Quad_Stance_traj(RF_pha_st);
        LH_P_car_des=RF_P_car_des;LH_Pd_car_des=RF_Pd_car_des;
            %----�������ǿ���----
        if  roll>=roll_max %�Ҳ���
            LF_q0=-roll;%- roll - acos((1-0.35*tan(roll))/1);
            LF_qd0=-roll_d;%(- ((7*tan(roll)^2)/20 + 7/20)/(1 - ((7*tan(roll))/20 - 1)^2)^(1/2) - 1)*roll_d;
            LF_Q0=[LF_q0;LF_qd0];          
            RH_q0=-roll;RH_qd0=-1*roll_d;
            RH_Q0=[RH_q0;RH_qd0];
            Q0_des=[LF_Q0;Q0_des(3);Q0_des(4);RH_Q0;Q0_des(7);Q0_des(8)];
        elseif roll<=-roll_max
            LF_q0=-roll;%- roll + acos((1+0.35*tan(roll))/1);
            LF_qd0=-roll_d;%(- ((7*tan(roll)^2)/20 + 7/20)/(1 - ((7*tan(roll))/20 + 1)^2)^(1/2) - 1)*roll_d;
            LF_Q0=[LF_q0;LF_qd0];
            RH_q0=-roll;RH_qd0=-1*roll_d;
            RH_Q0=[RH_q0;RH_qd0];
            Q0_des=[LF_Q0;Q0_des(3);Q0_des(4);RH_Q0;Q0_des(7);Q0_des(8)];
        elseif roll>-roll_max && roll<roll_max
            Q0_des=[0;0;0;0;0;0;0;0];
        end
    end
    [LF_P_polar_des,LF_Pd_polar_des]=carTopolar(LF_P_car_des,LF_Pd_car_des);
    [RF_P_polar_des,RF_Pd_polar_des]=carTopolar(RF_P_car_des,RF_Pd_car_des);
    [RH_P_polar_des,RH_Pd_polar_des]=carTopolar(RH_P_car_des,RH_Pd_car_des);
    [LH_P_polar_des,LH_Pd_polar_des]=carTopolar(LH_P_car_des,LH_Pd_car_des);  
end
y=[LF_P_polar_des;RF_P_polar_des;LF_Pd_polar_des;RF_Pd_polar_des;...
   RH_P_polar_des;LH_P_polar_des;RH_Pd_polar_des;LH_Pd_polar_des;Q0_des];
