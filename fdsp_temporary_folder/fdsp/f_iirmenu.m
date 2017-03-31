function hm_iir = f_iirmenu (inputstr,plotstr,proto)

%F_IIRMENU: Set up IIR filter design prototype menu
%
% Usage: hm_iir = f_iirmenu (inputstr,plotstr,proto)
%
% Inputs: 
%         inputstr = callback string to compute input
%         plotstr  = callback string to generate plot
%         proto    = prototype analog filter
% Outputs:
%          hm_iir = array of menu handles

cstr = ['for i = 1 : 4, '...
        '   if i == proto, '...
        '      set (hm_iir(i+1),''Checked'',''on''), '...
        '   else, '...
        '      set (hm_iir(i+1),''Checked'',''off''), '...
        '   end, '...
        'end, '...
        inputstr ...
        plotstr ];

hm_iir(1) = uimenu (gcf,'Label','Prototype');
   
cback1 = ['proto=1; ' cstr];
hm_iir(2) = uimenu (hm_iir(1),'Label','Butterworth filter','Callback',[cback1 inputstr plotstr]);

cback2 = ['proto=2; ' cstr];
hm_iir(3) = uimenu (hm_iir(1),'Label','Chebyshev-I filter','Callback',[cback2 inputstr plotstr]);

cback3 = ['proto=3; ' cstr];
hm_iir(4) = uimenu (hm_iir(1),'Label','Chebyshev-II filter','Callback',[cback3 inputstr plotstr]);

cback4 = ['proto=4; ' cstr];
hm_iir(5) = uimenu (hm_iir(1),'Label','Elliptic filter','Callback',[cback4 inputstr plotstr]);

for i = 1 : 4
    if i == proto
        set (hm_iir(i+1),'Checked','on')
    else
        set (hm_iir(i+1),'Checked','off')
    end
end
