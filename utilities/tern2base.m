function [A,B,C] = tern2base( name_E, E, wsum, extra )
%tern2base determines the edge A,B,C coordinates from one ternary coordinate
%
%   Take a name and a matrix of coordinates for that name, and obtains
%   A,B,C at the base of the axis and the other side. Wsum is needed to
%   compute units, if not given it is assumed to be one. The dimension of
%   A,B,C is Nd+1 compared to E, with the outside dimension ranging 1:,
%   for the near and far axes respectively ( e.g. for E=E(1:N):
%   A=A(1:N,1:2), B=B(1:N,1:2), ...) NOTE: E is squeezed so any weirdly
%   shaped matricies with interior 1's (e.g. 3x1x5) will return A/B/C
%   without the single dimension.
%
%   "extra_min" is an optional argument to add a length to the lower base,
%   mainly used to get "ticks" on ternary axes
    
    % First check if length is specified
    if (nargin<2)
        error('Too few Arguments')
    elseif (nargin<3)
        wsum = 1.0;
    end
    
    % Set extra min to zero, unless given
    if (nargin<4)
        extra = 0.0;
    end
    
    %% Get integer indices from name
    
    % Determine indicies from names
    idx_E = identify_ternary_axis( name_E );
    
    % Linearize E to vector
    Esize = size(E); % store size before vecorizing
    E = E(:);
    
    % Intialize A, B, C
    A = zeros( numel(E), 2 );
    B = zeros( numel(E), 2 );
    C = zeros( numel(E), 2 );
    
    % Get Difference of wsum and E
    Ediff = wsum - E;
    
    % Check if this reuslts in any negative values
    if min(Ediff) < 0.0
       error('Some values in Ediff result in <0 values with given wsum') 
    end
    
    % Do Type 1 (E=A) as the default
    
    % First point, on the axes or below it
    A(:,1) = E;     
    B(:,1) = -extra;
    C(:,1) = Ediff+extra;
    
    % Second Point, on the far side
    A(:,2) = E;
    B(:,2) = Ediff;
    C(:,2) = 0;
     
    % Swap to match the other two cases
    if  (idx_E==2)
        E = B; B = A; A = C; C = E;
    elseif (idx_E==3)
        E = B; B = C; C = A; A = E;
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

