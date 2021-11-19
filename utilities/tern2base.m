function [A,B,C] = tern2base( name_E, E, wlimits, margin )
%tern2base determines the A,B,C coordinates for the edges of the ternary,
%   for any line going through the ternary plot
%   
%   For example: if a user gives E=0.5 and name_E='B', A/B/C are the
%   coordinates to BOTH: the intercept of E=B=0.5 on the B axis, and the
%   intercept on the C axis. 
%
%   Shape of A/B/C: All N values of E(1:N) given are stored in rows, and
%   the Adjacent Axis (E) and Opposite Axis intercepts are stored in
%   columns. Hence, size(A) = size(B) = size(C) = [N,2]. "Opposite" axis
%   from the intercept is to the right: B for E=A, C for E=B, A for E=C
%
%   NOTE: E is squeezed so any weirdly shaped matricies with interior 1's
%   (e.g. 3x1x5) will return A/B/C without the single dimension.
%  
%   "margin" is an optional argument to add a length outside the axes,
%   mainly used to get coordinates of "ticks" outside the ternary axes.
%   If margin is a single value, only the adjacent E
    
    % Check Arguments
    arguments
        name_E   (1,1) {mustBeNonempty}
        E        (:,:) double {mustBeNonempty,mustBeReal}
        wlimits  (2,3) double {mustBeInteger} = ternary_axes_limits
        margin   (1,1) double {mustBeReal} = 0.0 
    end
    
    %% Get integer indices from name
    
    % Compute wsum, any valid point will do
    wsum = sum( wlimits(1,1)+wlimits(2,2)+wlimits(1,3) );
    
    % Determine indicies from names
    idx_E = identify_ternary_axis( name_E );
    
    % Linearize E to vector
    Esize = size(E); % store size before vecorizing
    E = E(:);
    
    % Intialize A, B, C
    A = zeros( numel(E), 2 );
    B = zeros( numel(E), 2 );
    C = zeros( numel(E), 2 );
     
    % Swap to match the other two cases
    if (idx_E==1)
        % First point, on the axes or below it
        A(:,1) = E;     
        B(:,1) = wlimits(1,2) - margin;
        C(:,1) = wsum - E - wlimits(1,2) + margin;
        % Second Point, on the far side
        A(:,2) = E;
        B(:,2) = wsum - E - wlimits(1,3);
        C(:,2) = wlimits(1,3);
    elseif  (idx_E==2)
        % First point, on the axes or below it
        A(:,1) = wsum - E - wlimits(1,3) + margin;
        B(:,1) = E;
        C(:,1) = wlimits(1,3) - margin;
        % Second Point, on the far side
        A(:,2) = wlimits(1,1);
        B(:,2) = E;
        C(:,2) = wsum - E - wlimits(1,1);
    elseif (idx_E==3)
        % First point, on the axes or below it
        A(:,1) = wlimits(1,1) - margin;
        B(:,1) = wsum - E - wlimits(1,1) + margin;
        C(:,1) = E;
        % Second Point, on the far side
        A(:,2) = wsum - E - wlimits(1,2);
        B(:,2) = wlimits(1,2);
        C(:,2) = E;
    end
    
    % Remove redundant 1's to prevent extra incidices
    Esize( Esize==1 ) = [];
    if (isempty(Esize))
       Esize = 1; 
    end
    
    % Reshape A/B/C
    A = reshape( A, [Esize,2] );
    B = reshape( B, [Esize,2] );
    C = reshape( C, [Esize,2] );
    
end

