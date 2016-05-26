within Annex60.Fluid.Storage.BaseClasses;
model GeometryKlopper
  parameter Integer nLay(min = 2) "number of tank layers";
  parameter Modelica.SIunits.Volume VTan "Tank volume (m3)";
  parameter Modelica.SIunits.Length hTan
    "Height of tank (without insulation) (m)";

  parameter Modelica.SIunits.Length dTan = (4*VTan/Modelica.Constants.pi/(hTan-0.1355*(4*VTan/Modelica.Constants.pi/hTan)^0.5))^0.5
    "maximum storage tank diameter, without insulation this is an approximate formula which results in an error less than 1pct when the ratio hTan/dTan > 1 . the exact diameter should be obtained from  hTan = (4*VTan+Modelica.Constants.pi*dTan^3*0.1355)/(Modelica.Constants.pi*dTan^2)";
  parameter Modelica.SIunits.Length[nLay+1] rLay = {
      if (k-1)/nLay*hTan < dTan*(1-cos(asin(0.4/0.9))) then
        dTan*sin(acos(1-(k-1)/nLay*hTan/dTan))
      elseif (k-1)/nLay*hTan < dTan*(1-0.9*cos(asin(0.4/0.9))) then
        dTan*(0.4+0.1*sin(acos((dTan*(1-0.9*cos(asin(0.4/0.9)))-(k-1)/nLay*hTan)/0.1/dTan)))
      elseif hTan-(k-1)/nLay*hTan > dTan*(1-0.9*cos(asin(0.4/0.9))) then
        dTan/2
      elseif hTan-(k-1)/nLay*hTan > dTan*(1-cos(asin(0.4/0.9))) then
        dTan*(0.4+0.1*sin(acos((dTan*(1-0.9*cos(asin(0.4/0.9)))-hTan+(k-1)/nLay*hTan)/0.1/dTan)))
      else
        dTan*sin(acos(1-hTan/dTan+(k-1)/nLay*hTan/dTan))
    for k in 1:nLay+1} "storage radius at top of node k";
  parameter Modelica.SIunits.Volume[nLay] VLay={VTan*(1/3*Modelica.Constants.pi*hTan/nLay*(rLay[k+1]-rLay[k])^2 + Modelica.Constants.pi*hTan/nLay*rLay[k]*(rLay[k+1]-rLay[k]) + Modelica.Constants.pi*hTan/nLay*rLay[k]^2)/sum(1/3*Modelica.Constants.pi*hTan/nLay*(rLay[k+1]-rLay[k])^2 + Modelica.Constants.pi*hTan/nLay*rLay[k]*(rLay[k+1]-rLay[k]) + Modelica.Constants.pi*hTan/nLay*rLay[k]^2 for k in 1:nLay) for k in 1:nLay}
    "volume of node k";
equation

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-40,74},{40,46}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,60},{40,-60}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-40,-46},{40,-74}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));

end GeometryKlopper;
