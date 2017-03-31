function f_drawrate (h,colors,fsize)

%F_DRAWRATE: Draw a block diagram for GUI module g_multirate
%
% Usage: f_drawrate (h,colors,fsize);
%
% Input: 
%        h      = axes handle
%        colors = array of plotting colors
%        fsize  = font size 

% Initialize

ylim = get(h,'Ylim');
xlim = get(h,'Xlim');
y0 = (ylim(2)-ylim(1))/2;
axes (h);
hold on
arrow = 0.08;
boxwidth = 0.15;
boxheight = 0.15;
circle = 0.02;

% Draw block diagram

f_circle (0.5-2*arrow-1.5*boxwidth,y0,circle,colors(1,:));
text (0.5-2*arrow-1.5*boxwidth-0.04,y0,'x(k)','Color',colors(1,:),'HorizontalAlignment','center',...
      'FontName','FixedWidthFontName','FontSize',fsize);
f_vector (0.5-2*arrow-1.5*boxwidth+0.5*circle,y0,1,0,arrow-0.5*circle,colors(1,:))
f_block (0.5-1.5*boxwidth-arrow,y0-0.5*boxheight,boxwidth,boxheight,colors(1,:))
text (0.5-boxwidth-arrow,y0,'\uparrow L','HorizontalAlignment','center',...
      'FontName','FixedWidthFontName','FontSize',fsize)

f_vector (0.5-arrow-0.5*boxwidth,y0,1,0,arrow,colors(2,:))
f_block (0.5-0.5*boxwidth,y0-0.5*boxheight,boxwidth,boxheight,colors(2,:))
text (0.5,y0,'H_0(z)','HorizontalAlignment','center',...
      'FontName','FixedWidthFontName','FontSize',fsize)

f_vector (0.5+0.5*boxwidth,y0,1,0,arrow,colors(3,:))
f_block (0.5+0.5*boxwidth+arrow,y0-0.5*boxheight,boxwidth,boxheight,colors(3,:))
text (0.5+boxwidth+arrow,y0,'\downarrow M','HorizontalAlignment','center',...
      'FontName','FixedWidthFontName','FontSize',fsize)

f_line (0.5+1.5*boxwidth+arrow,y0,1,0,arrow-0.5*circle,colors(3,:))
f_circle (0.5+1.5*boxwidth+2*arrow,y0,circle,colors(3,:))
text (0.5+1.5*boxwidth+2*arrow+0.04,y0,'y(k)','Color',colors(3,:),'HorizontalAlignment','center',...
      'FontName','FixedWidthFontName','FontSize',fsize);
 