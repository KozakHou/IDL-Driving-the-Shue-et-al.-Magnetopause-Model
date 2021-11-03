;1
restore,'wind_mfi.save'
jd_mfi=julday(month,day,year,hour,minute,second)
restore,'wind_swe.save'
jd_swe=julday(month,day,year,hour,minute,second)
np_new=interpol(np,jd_swe,jd_mfi)
vx_new=interpol(vx,jd_swe,jd_mfi)
np=np_new
vx=vx_new
save,year,month,day,hour,minute,second,np,bx,by,bz,FILENAME='wind_merge.save'

;2
restore,'wind_all.save'
window,0,xsize=600,ysize=650
!p.background=255
device,decomposed=0
!p.color=0
!y.margin=[4,4]
theta=(findgen(360)-180)*!dtor
dp=1.6726E-6*NP*VX*VX
a1=(0.58-0.010*BZ)*(1+0.0010*dp)
for i=0,2799,80 do begin
  plot,[0,1],xrange=[-60,20],yrange=[-40,40],xtitle='X(Re)',ytitle='Y(Re)',$
    xstyle=1,ystyle=1,/nodata,title='     0  /  0   /               :      !c Bz=             nT,  Dp=               nPa'
  xyouts,-38.6,44,month[i+80],size=1.4 
  xyouts,-31,44,day[i+80],size=1.4
  xyouts,-27,44,year[i+80],size=1.4
  xyouts,-11,44,hour[i+80],size=1.4
  xyouts,-7,44,minute[i+80],size=1.4
  xyouts,-45,41.5,Bz[i+80],size=1.4
  xyouts,-23,41.5,Dp[i+80],size=1.4
  x=[-60,20]
  y=[0,0]
  oplot,x,y,linestyle=1
  x1=[0,0]
  y1=[-40,40]
  oplot,x1,y1,linestyle=1
  if BZ[i+80] ge 0 then begin
    r0=(11.4+0.013*BZ[i+80])*dp[i+80]^(-1/6.6)
    r1=r0*(2./(1.+cos(theta)))^a1[i+80]
    oplot,r1*cos(theta),r1*sin(theta),linestyle=0,thick=2
  endif else begin   
    r2=(11.4+0.14*BZ[i+80])*dp[i+80]^(-1/6.6)
    r3=r2*(2./(1.+cos(theta)))^a1[i+80]
    oplot,r3*cos(theta),r3*sin(theta),linestyle=0,thick=2
  endelse
  s=tvrd()
  g=finite(bz[i+80])
  h=where(g ge 1)
  j=where(g le 0)
  if g[h] eq 1 then begin
        r=s
  endif else begin
        s=s
  endelse
  write_gif,'Shue et al. [1997].gif',r,/multiple,delay_time=20,REPEAT_COUNT=0
endfor
end

