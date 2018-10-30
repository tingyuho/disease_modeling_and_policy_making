% RAMP run for whole budget horizon yearsm, one time MF-RA, no roll out
%P_male_initial: population size at time 0
%P_female_initial: population size at time 0
function [QALY_LFA, x_LFA] = RAMP(selected_policies, decision_period, grid_size, n_d, P_ongoing, P_waiting, Reinfection_probability, health_utiliy, CS, CT, Quarterly_Budget, P_male_initial ,P_female_initial, n_q_budget, initial_begin_age)
        
    n_policy = size(selected_policies,1); % number of selected policies
    QALY_LFA = 0;
    alpha = 1;
    beta = 1;
    for i=1:1:n_policy % for each in selected policy, find the best one using multi-fidelity model
        % compare E functions
        d = 1;
        P_male = P_male_initial;
        P_female = P_female_initial;
        Opt_TR_BP = zeros(1,n_d);
        QALY_sum_temp = 0;
        for d=1:1:n_d
            if d<=5
                age = initial_begin_age;
            elseif (d > 5) && (d<=10) 
                age = initial_begin_age+10;
            else    
                age = initial_begin_age+20;
            end
            % examine determined policy before decision period
            if  d <= decision_period
                Opt_TR_BP(d) = selected_policies(i,d);
                Opt_SR_BP(d) = 1-selected_policies(i,d);
                [sum_QALY,P_male,P_female,] = two_year_sum_QALY_budget_include_num_treatment (P_ongoing, P_waiting, Reinfection_probability, health_utiliy, CS, CT, P_male, P_female, Opt_SR_BP(d), Opt_TR_BP(d), n_q_budget, Quarterly_Budget, age, (d-1)*8 , 0, 0);                
            % examine later policy after decision period
            else
                [Sum_QALY, Opt_SR_BP(d), Opt_TR_BP(d)] = Low_Fidelity_Approximation(grid_size, P_ongoing, P_waiting, Reinfection_probability, health_utiliy, CS, CT, Quarterly_Budget, P_male, P_female, age); %optimal screening ratio wrt budget, optimal Q
                [sum_QALY, P_male,P_female, ] = two_year_sum_QALY_budget_include_num_treatment (P_ongoing, P_waiting, Reinfection_probability, health_utiliy, CS, CT, P_male, P_female, Opt_SR_BP(d), Opt_TR_BP(d), n_q_budget, Quarterly_Budget, age, (d-1)*8 ,0,0);
            end
            QALY_sum_temp = QALY_sum_temp+sum_QALY;
        end
        for q=0:1:4*(100-initial_begin_age-n_d*2)-1
            age = initial_begin_age+floor(q/4)+n_d*2; %+n_d*2
            [Q_male, Q_female, M_male, M_female] = Q_M_matrix(P_ongoing, P_waiting, Reinfection_probability, 0, 0, 0 ,0, 0 ,0, 0 ,0 ,0 ,0 ,0 ,0, age, alpha, beta);
            [sum_QALY, P_male, P_female] = quartly_year_sum_QALY (health_utiliy, P_male, P_female, Q_male, Q_female, M_male, M_female);
            QALY_sum_temp = QALY_sum_temp+sum_QALY*(1+0.0076)^(-(4*2*n_d)-q);
        end
        
        if QALY_LFA < QALY_sum_temp
            QALY_LFA = QALY_sum_temp;
            x_LFA = Opt_TR_BP;
        end
    end
   
end