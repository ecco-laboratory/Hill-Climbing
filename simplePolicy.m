% Define a simple policy function
function action = simplePolicy(state, terminalState, actions)
    if state(2) < terminalState(2)
        action = actions(4); % Move E
    elseif state(1) < terminalState(1)
        action = actions(2); % Move S
    else
        action = actions(randi(length(actions))); % Random action if already at the terminal state
    end
end
