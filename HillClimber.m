classdef HillClimber < rl.env.MATLABEnvironment

    properties

        GridSize = [100, 200];                       % Size of the grid
        CurrentState = [2, 1];                   % Current position in the grid
        TerminalState = [100,200];                  % Goal position in the grid
        Obstacles = [];                         % Positions of obstacles in the grid
        Rewards = compute_rewards(100,200);
        Elevation = compute_elevation(100,200);

    end
    
    methods
        function this = HillClimber()
            % Define the observation and action spaces
            ObservationInfo = rlNumericSpec([2 1]);
            ObservationInfo.Name = 'Grid State';
            ActionInfo = rlFiniteSetSpec(1:4); 
            ActionInfo.Name = 'Grid Action';
            this = this@rl.env.MATLABEnvironment(ObservationInfo, ActionInfo);
        end
        
        function [Observation, Reward, IsDone, LoggedSignals] = step(this, Action)
            LoggedSignals = []; % Initialize LoggedSignals
            
          
            [east_energy, north_energy] = gradient(this.Elevation);
            west_energy = -1*east_energy;
            south_energy = -1*north_energy;

                % Standard grid movement logic
                nextState = this.CurrentState;
                switch Action
                    case 1 % N
                        nextState = this.CurrentState + [-1, 0];

                        if all(nextState > 0) && all(nextState <= this.GridSize) 
                            energy = north_energy(nextState(1),nextState(2));
                        else
                        energy = 0;
                        end
                    case 2 % S
                        nextState = this.CurrentState + [1, 0];
                        if all(nextState > 0) && all(nextState <= this.GridSize)
                            energy = south_energy(nextState(1),nextState(2));
                        else
                        energy = 0;
                        end
                    case 3 % E
                        nextState = this.CurrentState + [0, -1];
                        if all(nextState > 0) && all(nextState <= this.GridSize)
                            energy = east_energy(nextState(1),nextState(2));
                        else
                        energy = 0;
                        end
                    case 4 % W
                        nextState = this.CurrentState + [0, 1];
                        if all(nextState > 0) && all(nextState <= this.GridSize)
                            energy = west_energy(nextState(1),nextState(2));
                        else
                         energy = 0;
                        end
                end
                
               if all(nextState > 0) && all(nextState <= this.GridSize) 
                  
                    this.CurrentState = nextState;
                    skip = false;
                else
                    % disp('At an obstacle, take another action!')
                    skip = true;
                end
          
            this.CurrentState = nextState;

            
            % Set Observation, Reward, IsDone, and LoggedSignals
            Observation = this.CurrentState';
            if ~skip
                if isequal(this.CurrentState, this.TerminalState)
                    Reward = 10 + 10*this.Rewards(this.CurrentState(1),this.CurrentState(2)) + energy -.1;
                    this.Rewards(this.CurrentState(1),this.CurrentState(2)) = this.Rewards(this.CurrentState(1),this.CurrentState(2))/2;
                    IsDone = true;
                else
                    Reward =  10*this.Rewards(this.CurrentState(1),this.CurrentState(2)) + energy -.1;
                    this.Rewards(this.CurrentState(1),this.CurrentState(2)) = this.Rewards(this.CurrentState(1),this.CurrentState(2))/2;
                    IsDone = false;
                end
            else
                Reward = -.1;
                IsDone = false;
            end


        end
        
        function InitialObservation = reset(this)
            % Reset the environment to the initial state
            this.CurrentState = [1, 1];
            % Reset action space to initial action space
            this.ActionInfo = rlFiniteSetSpec(1:4);
            InitialObservation = this.CurrentState';
        end
        function actionInfo = getActionInfo(this)
            % Method to get the current action space information
            actionInfo = this.ActionInfo;
        end
    end
end


