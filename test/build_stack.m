function stack = build_stack(grating)
% BUILD_STACK  Initialise a layer stack from a grating geometry.
%
% The stack grows upward in z.  The substrate sits below z = 0.
% Vacuum (n = 1) is the incident medium above the topmost layer.
%
% The grating surface is the shaped substrate boundary.
% Coating layers are added above it with add_layer().
%
% OUTPUT  stack struct fields:
%   .grating          the grating descriptor from build_grating()
%   .layers           cell array of layer descriptors (empty at start)
%   .total_height_nm  current total coating height above the grating valleys

stack.grating         = grating;
stack.layers          = {};
stack.total_height_nm = 0;

end
