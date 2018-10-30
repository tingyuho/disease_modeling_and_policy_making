function [QALY_lb,x_lb] = RAMP_PBnB (QALY_no_policy, delta_threshold, Yearly_Budget, P_ongoing, P_waiting, Reinfection_probability, health_utiliy, grid_size, n_d, n_p, CS, CT, P_male_initial ,P_female_initial, n_q_budget, initial_begin_age)

format shortG
% ==============step 0: Initialization==============
tic;
t_timer = zeros(n_d,1);
Quarterly_Budget = Yearly_Budget/4; % budget per time period
policy_index = 1; 
discritize_budget = [0:1/(n_p-1):1];
up_vector = ones(n_p,n_d)*2;

d=1;
n_prune=0;
QALY_lb = QALY_no_policy +0.1;
x_lb = zeros (1,n_d);
QALY_ub = inf;
policy_stack = up_vector;%zeros(n_p,n_d);
QALY_all_policy = zeros (n_p,1); % upper QALYs or actual QALYs;
policy_stack(1:n_p,1) =  discritize_budget'; % the first n_p policy at the first decision period

while ((((QALY_ub-QALY_lb)/(QALY_lb-QALY_no_policy))>delta_threshold) && (d<=n_d))
    d
    % ============== step 1: branching ==============
    
    % ============== step 2: upper bound ==============
    
    for i = policy_index:1:size(policy_stack,1)
        QALY_all_policy(i) = QALY_upper_bound_calculator (policy_stack(i,:), d, n_d, n_q_budget, P_ongoing, P_waiting, health_utiliy, CS, CT, Quarterly_Budget, Reinfection_probability, initial_begin_age, P_male_initial, P_female_initial);
    end
    [QALY_ub,QALY_ub_index] = max(QALY_all_policy(policy_index:size(policy_stack,1)));
    x_ub = policy_stack(QALY_ub_index+policy_index-1,:)
    % ============== step 3: Elite set ==============
    
    [sortedValues,sortIndex] = sort(QALY_all_policy(policy_index:size(policy_stack,1)),'descend');  %# Sort the values in
    if (d-1)*n_p <= size(sortedValues)
        Elite_Array = sortIndex(1:(d-1)*n_p)+(policy_index-1);
    else
        Elite_Array = sortIndex+(policy_index-1);
    end

    % ============== step 4: RAMP ==============  
    
    if d == 1     
        [QALY_lb_temp, x_lb_temp] = RAMP(policy_stack(1:n_p,:), d, grid_size, n_d, P_ongoing, P_waiting, Reinfection_probability, health_utiliy, CS, CT, Quarterly_Budget, P_male_initial ,P_female_initial, n_q_budget, initial_begin_age);
    elseif d > 1 && size(Elite_Array,1) ~= 0
        [QALY_lb_temp, x_lb_temp] = RAMP(policy_stack(Elite_Array,:), d, grid_size, n_d, P_ongoing, P_waiting, Reinfection_probability, health_utiliy, CS, CT, Quarterly_Budget, P_male_initial ,P_female_initial, n_q_budget, initial_begin_age);
    end
    % ============== step 5: Lower bound computation ==============
    if QALY_lb_temp > QALY_lb
        %sprintf('QALY_lb_temp= %9.3f', QALY_lb_temp)
        %sprintf('QALY_lb= %9.3f', QALY_lb)
        QALY_lb = QALY_lb_temp;
        x_lb = x_lb_temp;
    end

    % ============== step 6: Fathoming and Branch==============
    
    size_policy_stack_before_branching = size(policy_stack,1);
    if d < n_d
        for i = policy_index:1:size_policy_stack_before_branching
            if QALY_all_policy(i)< QALY_lb
                n_prune = n_prune+1;
            end
            if QALY_all_policy(i) >= QALY_lb
                new_policy = ones(1,n_d)*2;
                new_policy(1:d) = policy_stack(i,1:d);
                new_policy = repmat(new_policy, n_p, 1);
                new_policy (:,d+1) = discritize_budget';
                policy_stack = [policy_stack;new_policy];

            end
        end        
    end

    % ============== step 7:Stopping rule ==============
    % stopiing rule is in while loop
    
    policy_index = size_policy_stack_before_branching + 1;
    d = d+1;
    sprintf('QALY_lb= %9.3f', QALY_lb)
    sprintf('QALY_ub= %9.3f', QALY_ub)
    sprintf('epsilon= %1.13f', (QALY_ub-QALY_lb)/(QALY_lb-QALY_no_policy))
    x_lb
    n_prune
    if d == 1
        t_timer(1)=toc;
    else
        t_timer(d)=toc;
    end
    t_timer(d)
end
t_timer
n_prune