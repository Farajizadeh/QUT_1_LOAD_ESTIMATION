clear all
close all

%% RECEIVER CURRENT SHOULD BE MULTIPLIED BY TWO

%% SPECIFICATIONS
R_L=1.5*2;
V_DC=180;


D=[0:1:15];
LENGTH1=7682;
LENGTH2=7682;
%% DATA ACQUISATION
m=1;
if 1
    %%
    for k=D(1:16)
        t_exp=xlsread(['A1\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['A3:A' num2str(LENGTH1)]);
        t_exp=t_exp-t_exp(1);
        s_dq=xlsread(['A1\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['B3:B' num2str(LENGTH1)]);
        v_in=xlsread(['A1\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['C3:C' num2str(LENGTH1)]);
        v_cp=xlsread(['A1\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['D3:D' num2str(LENGTH1)]);
        i_ls=xlsread(['A1\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['E3:E' num2str(LENGTH1)]);
        i_t=xlsread(['A2\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['B3:B' num2str(LENGTH1)]);
        v_r=1*xlsread(['A2\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['C3:C' num2str(LENGTH1)]);
        i_r=4*xlsread(['A2\scope_' num2str(k) '.csv'],['scope_' num2str(k)],['D3:D' num2str(LENGTH1)]);
        
        [F_EXPC,V_INC]=FFFT(t_exp,v_in);
        [F_EXPC,I_LSC]=FFFT(t_exp,i_ls);
        [F_EXPC,V_RC]=FFFT(t_exp,v_r);
        [F_EXPC,I_RC]=FFFT(t_exp,i_r);
        V_IN(m)=V_INC(3);
        I_LS(m)=I_LSC(3);
        V_R(m)=V_RC(3);
        I_R(m)=I_RC(3);
        
        p_in(m)=trapz(v_in.*i_ls)./length(v_in);
        p_vout(m)=trapz(v_r.*v_r)./(length(v_r));
        p_iout(m)=trapz(i_r.*i_r)./(length(i_r));
        p_out(m)=trapz(v_r.*i_r)./(length(i_r));
        
        v_cpc_d(m)=v_cp(4748);
        v_cpc_q(m)=v_cp(3748);
        
        clc
        display(['Percentage: ' sprintf('%0.2f',100*m/16) '%'])
        
        figure(100)
        hold on
        plot(t_exp,v_in,'r')
        %plot([t_exp],v_in-[v_in(2:end);v_in(1)],'r')
        plot(t_exp,v_cp,'b')
        
        figure(101)
        hold on
        plot(t_exp,v_in/100,'r')
        plot(t_exp,i_ls/4,'b')
        
        m=m+1;
    end
    save('DATA')
else
    load('DATA')
end

figure(1)
hold on
plot(D,p_in,'r');
plot(D,real(V_IN.*conj(I_LS))/2,'--k')
plot(D,v_cpc_d*3.4267,'c')
plot(D,p_vout/R_L,'b');
plot(D,p_iout*R_L,'--b');
plot(D,p_out,'k')
legend('P_{in}','P_{in,FFT}','P_{in,est}','P_{v,out}','P_{i,out}','P_{out}')
ylabel('P_{in/out} (W)')
grid on

figure(2)
hold on
plot(D,imag(V_IN.*conj(I_LS))/2,'--k')
plot(D,v_cpc_q*1.9268,'c')
legend('Q_{in,FFT}','Q_{in,est}')
ylabel('Q_{in/out} (VAr)')
grid on

figure(3)
hold on
plot(D,p_vout./(p_in*R_L),'b');
plot(D,(p_iout*R_L)./(p_in),'--b');
plot(D,p_out./p_in,'k');
legend('\eta_{v^2}','\eta_{i^2}','\eta_{vi}')
grid on