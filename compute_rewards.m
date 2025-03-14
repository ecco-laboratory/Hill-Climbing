function rewards = compute_rewards(m,n)

% m = 100; 
% n = 200;
environment = zeros(m,n);
rewards = zeros(m,n);


ridge_locations = [30 60 90]; %locations of ridges and peaks in y


reward_locations = [10 10; 10 100; 10 190;...
    40 10;  40 100; 40 190;...
    70 10;  70 100;  70 190];

for r=1:size(environment,1)

    for e = 1:size(environment,2)

        environment = environment + sum(ridge_locations>r)/200*gauss2d(environment,10,[r e]);

        if any(e==reward_locations(:,2)) && any(r==reward_locations(:,1))


        rewards = rewards + gauss2d(environment,10,[r e])/log(r);

        end

    end

end