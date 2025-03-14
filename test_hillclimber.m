% Create an instance of the CustomGridWorld environment
env = HillClimber();
% Reset the environment to the initial state
initialObservation = env.reset()
numEpisodes = 1;  % user defined
numSteps = 10000;     % user defined



R0 = env.Rewards;

for episode = 1:numEpisodes
    % Reset the environment at the start of each episode
    initialObservation = env.reset();
    disp('Starting a new episode')
    disp(['Episode ', num2str(episode), ' started']);
    disp(['Initial State: ', mat2str(initialObservation)]);
    
    for step = 1:numSteps
        % Get the current action space
        actionInfo = env.getActionInfo();
        actions = actionInfo.Elements;
        

        % Get the current state
        currentState = env.CurrentState;

        % Select an action using the policy
        action = simplePolicy(currentState, env.TerminalState, actions);
        
        
        % Take the action and get the next observation, reward, and done flag
        [observation, reward, isDone, loggedSignals] = env.step(action);
        

    
        % Display the results of the step
        disp(['Step ', num2str(step)]);
        disp(['Action: ', num2str(action)]);
        disp(['State: ', mat2str(observation)]);
        disp(['Reward: ', num2str(reward)]);
        disp(['IsDone: ', num2str(isDone)]);

        figure(1); imagesc(R0-env.Rewards);
        drawnow;snapnow;
        
        % If the episode is done, break the loop
        if isDone
            disp('Episode finished.');
            disp('-----------------------');
            break;
        end
    end
end


%%

opt = rlTrainingOptions(...
    MaxEpisodes=1000,...
    MaxStepsPerEpisode=1000,...
    StopTrainingCriteria="AverageReward",...
    StopTrainingValue=5000, ...
    Verbose=true,...
    Plots="none");


qAgent = rlDQNAgent(getObservationInfo(env), ...
    getActionInfo(env));

qAgent.AgentOptions.EpsilonGreedyExploration.Epsilon = .3;
qAgent.AgentOptions.CriticOptimizerOptions.LearnRate = 0.1;

previousRngState = rng(0,"twister")

trainResults = train(qAgent,env,opt);