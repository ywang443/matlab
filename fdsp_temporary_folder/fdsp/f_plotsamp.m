function plotsamp (pv,haxis,hfs,xm,n,Fc,N,Vr,userinput,fsize)

%F_PLOTSAMP: Plot selective view for GUI module G_SAMPLE
%
% Usage: plotsamp (pv,hfs,xm,m,Fc,N,Vr)
%
% Inputs: 
%         pv        = view selection (1 to 4)
%         haxis     = handle to axes for plot
%         hfs       = handle to the fs slider
%         xm        = input selection (1 to 5)
%         n         = anti-aliasing filter order (0 = no filter)
%         Fc        = anti-aliasing filter cutoff frequency
%         N         = ADC precision (bits)
%         Vr        = ADC reference voltage
%         userinput = string specifying name of user-defined
%                     M-file function when xm = 5.
%         fsize     = font size 

hold off
axes (haxis)
cla
fs = floor(get(hfs(1),'Value'));
colors = get(gca,'ColorOrder');

% Construct title

switch pv
    
    case 1, s1 = 'Time signals, ';
    case 2, s1 = 'Magnitude spectra, ';
        
end
 
switch xm
    
    case 1, s2 = 'consant input';
    case 2, s2 = 'damped exponential input';
    case 3, s2 = 'cosine input';
    case 4, s2 = 'square wave input';
    case 5,
        user1 = f_cleanstring (userinput);
        s2 = sprintf ('user-defined input from file %s',user1);
end
s3 = sprintf(': n=%d, F_c=%g, N=%d, V_r=%g, f_s=%g',n,Fc,N,Vr,fs);
if pv <= 2
   caption = [s1 s2 s3];
end

% Compute anti-aliasing filter

if n > 0
   [b,a] = f_butters (Fc,Fc+1,.1,.1,n); 
end

if (pv == 1) 
   
% Plot time signals   
   
   T = 1/fs;
   tf = 4.0;
   td = [0 : T : tf];
   nx = length(td);
   p = max(10*nx,100);	
   t = linspace(0,tf,p)';
   for i = 1 : p
      x_a(i) = f_funx(t(i),xm,userinput);
   end
   X = zeros(p,2);
   if n > 0
      options = [];
      y0 = zeros(n,1);
	  [t,v] = ode23('f_butter',t,y0,options,b,a,xm,userinput,X);
      x_b = v(:,1);
   else
      x_b = x_a;
   end
   
   if n > 0
      [td v] = ode23('f_butter',td,y0,options,b,a,xm,userinput,X);
 	  x = v(:,1);
   else
      for i = 1 : nx
         x(i) = f_funx(td(i),xm,userinput);
      end
   end
   
   plot(t,x_a,'LineWidth',1.5)
   hold on
   plot(t,x_b,'Color',colors(2,:),'LineWidth',1.0)
   xlim = get(gca,'Xlim');
   ylim = get(gca,'Ylim');
   if (xm >= 3) & (xm <= 4)
       set (gca,'Ylim',1.2*ylim)
   end

   [bin,di,xq] = f_adc(x,N,Vr);
   stem (td,xq,'filled','r.')
   plot ([t(1) t(p)],[0 0],'k')
   f_labels (caption,'t (sec)','x(t)','',fsize)
   hl = legend ('x_a(t)','x_b(t)','x(k)');
   set (hl,'FontName','FixedWidthFontName','FontSize',fsize)
   
elseif (pv == 2) 
   
% Plot spectra

   q = 256;
   fss = 4*fs;
   tf = (q-1)/fss;
   t = linspace(0,tf,q);
   freq = linspace(-fss/2,fss/2,q);
   for i = 1 : q
      x_a(i) = f_funx(t(i),xm,userinput);
   end
   X_a = f_unscramble(abs(fft(x_a)));
   
   X = zeros(q,2);   
   if n > 0
   	 options = [];
   	 y0 = zeros(n,1);
	 [t,v] = ode45('f_butter',t,y0,options,b,a,xm,userinput,X);
   	  x_b = v(:,1);
   else
      x_b = x_a;
   end
 
   X_b = f_unscramble(abs(fft(x_b)));
   h = plot(freq,X_a,freq,X_b);
   set (h(1),'LineWidth',1.5);
   
   hold on
   scale_1 = .5;
   X = scale_1*X_b;
   X(1:q/2) = X(1:q/2) + scale_1*X_b(q/2+1:q);
   X(q/2+1:q) = X(q/2+1:q) + scale_1*X_b(1:q/2);
   X(1:q/2) = X(1:q/2) + scale_1*X_b(q/4+1:3*q/4);
   X(q/2+1:q) = X(q/2+1:q) + scale_1*X_b(q/4+1:3*q/4);
   plot(freq,X,'r')
   
   scale_2 = 1.5;
   x_max = scale_2*max(X_a);
   plot ([-fs/2 -fs/2 fs/2 fs/2],...
         [0 x_max x_max 0],'k:')
   f_labels (caption,'f (Hz)','|X(f)|','',fsize)
   hl = legend ('|X_a(f)|','|X_b(f)|','|X(f)|','Scaled ideal filter');
   set (hl,'FontName','FixedWidthFontName','FontSize',fsize)
   
elseif (pv == 3)
   
% Plot filter magnitude response

   q = 256;	
   F_1 = 2*fs;
   freq = linspace(-F_1,F_1,q);
   if n > 0
      A = 1./sqrt(1 + (freq/Fc).^(2*n));
   else
      A = ones(length(freq));
   end
   plot (freq,A,'Color',colors(2,:))
   hold on
   x_max = 1.5;
   plot ([-fs/2 -fs/2 fs/2 fs/2],...
         [0 1 1 0],'k:')
   axis ([-F_1 F_1 0 1.5])  
   caption = ['Anti-aliasing filter magnitude response' s3];
   f_labels (caption,'f (Hz)','A(f)','',fsize)
   hl = legend ('Anti-aliasing filter','Ideal filter');
   set (hl,'FontName','FixedWidthFontName','FontSize',fsize)
   
elseif (pv == 4)
   
% Plot ADC Input/Output Characteristic

   p =401;	
   x_c = linspace(-Vr,Vr,p);
   dx = 2*Vr/2^N;
   for i = 1 : p
      [bin,y_c(i),y0] = f_adc(x_c(i),N,Vr);
   end
   plot ([-Vr Vr],[0 0],'k')
   ylim = 2^(N-1);
   hold on
   plot ([0 0],[-ylim,ylim],'k')
   plot (x_c,y_c,'Color',colors(3,:))
   axis ([-Vr Vr -ylim ylim])
   caption = ['ADC input-output characteristic' s3];
   f_labels (caption,'x_b (volt)','Decimal output','',fsize)
   box on
   
end   
