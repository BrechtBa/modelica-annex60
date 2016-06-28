within Annex60.Fluid.Storage.BaseClasses;
model ThirdOrderStratifier
  "Model to reduce the numerical dissipation in a tank"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model" annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0)
    "Small mass flow rate for regularization of zero flow";
  parameter Integer nSeg(min=4) "Number of volume segments";

  parameter Real alpha(
    min=0,
    max=1) = 0.7 "Under-relaxation coefficient (1: QUICK; 0: 1st order upwind)";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heatPort
    "Heat input into the volumes" annotation (Placement(transformation(extent={
            {90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput[nSeg - 1] m_flow
    "Mass flow rate between the volumes, m_flow[i] is positive when mass flows from volume i to volume i+1"
                                                                                                      annotation (Placement(transformation(
          extent={{-140,62},{-100,102}})));

  Modelica.Blocks.Interfaces.RealInput[nSeg - 1] H_flow
    "Enthalpy flow between the volumes,  H_flow[i] is positive when enthalpy flows from volume i to volume i+1"
                                                                                                      annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}})));

  Modelica.Fluid.Interfaces.FluidPort_a[nSeg] fluidPort(redeclare each package
      Medium =         Medium)
    "Fluid port, needed to get pressure, temperature and species concentration"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

//protected
  Modelica.SIunits.SpecificEnthalpy[nSeg] h
    "Extended vector with port enthalpies, needed to simplify loop";

  Modelica.SIunits.HeatFlowRate H_flow_upwind[nSeg-1]
    "Enthalpy flow computed using the 1st order upwind discretization scheme";

  Modelica.SIunits.HeatFlowRate H_flow_quick[nSeg-1]
    "Enthalpy flow computed using the QUICK discretization scheme";

  Modelica.SIunits.HeatFlowRate H_flow_vol[nSeg-1]
    "Enthalpy flow from volume i to volume i+1";

equation
  assert(nSeg >= 4,
  "Number of segments of the enhanced stratified tank should be no less than 4 (nSeg>=4).");

  // assign zero flow conditions at port
  fluidPort[:].m_flow = zeros(nSeg);
  fluidPort[:].h_outflow = zeros(nSeg);
  fluidPort[:].Xi_outflow = zeros(nSeg, Medium.nXi);
  fluidPort[:].C_outflow = zeros(nSeg, Medium.nC);

  // assign extended enthalpy vectors
  for i in 1:nSeg loop
    h[i] = inStream(fluidPort[i].h_outflow);
  end for;

  /*
  Volumes and flows between them
  |       i-1      |       i       |      i+1      |
  .               -->             -->
  .           m_flow[i-1]       m_flow[i]
  .           H_flow[i-1]       H_flow[i]
  .
  m_flow[i] > 0  (-->)
  H_flow_upwind[i] = m_flow[i]*( h[i] )
  H_flow_quick[i] = m_flow[i]*( 1/2*(h[i]+h[i+1]) - 1/8*(h[i-1]-2*h[i]+h[i+1]) )
  
  m_flow[i] < 0  (<--)
  H_flow_upwind[i] = m_flow[i]*( h[i+1] )
  H_flow_quick[i] = m_flow[i]*( 1/2*(h[i]+h[i+1]) - 1/8*(h[i+2]-2*h[i+1]+h[i]) )
  .
  */

  // enthalpy flow calculated with upwind discretization
  for i in 1:nSeg-1 loop
    H_flow_upwind[i] = semiLinear(m_flow[i],h[i],h[i+1]);
  end for;

  // enthalpy flow calculated with QUICK discretization
  for i in 1:nSeg-1 loop
    H_flow_quick[i] = semiLinear(m_flow[i], 1/2*(h[i]+h[i+1]) - 1/8*(h[if i==1 then 1 else i-1]-2*h[i]+h[i+1]),  1/2*(h[i]+h[i+1]) - 1/8*(h[if i==nSeg-1 then nSeg else i+2]-2*h[i+1]+h[i]));
  end for;

  // used enthalpy flow from node i to node i+1
  for i in 1:nSeg-1 loop
    H_flow_vol[i] = alpha*H_flow_quick[i] + (1-alpha)*H_flow_upwind[i];
  end for;

  for i in 1:nSeg loop
    // Add the difference back to the volume as heat flow. An under-relaxation is needed to reduce
    // oscillations caused by high order method
    heatPort[i].Q_flow = (if i==nSeg then 0 else H_flow_vol[i]-H_flow[i])-(if i==1 then 0 else H_flow_vol[i-1]-H_flow[i-1]);
  end for;
  annotation (Documentation(info="<html>
<p>
This model reduces the numerical dissipation that is introduced
by the standard first-order upwind discretization scheme which is
created when connecting fluid volumes in series.
</p>
<p>
The model is used in conjunction with
<a href=\"modelica://Modelica.Fluid.Storage.Stratified\">
Modelica.Fluid.Storage.Stratified</a>.
It computes a heat flux that needs to be added to each volume of <a href=\"modelica://Modelica.Fluid.Storage.Stratified\">
Modelica.Fluid.Storage.Stratified</a> in order to give the results that a third-order upwind discretization scheme (QUICK) would give.
</p>
<p>
The QUICK method can cause oscillations in the tank temperatures since the high order method introduces numerical dispersion.
There are two ways to reduce the oscillations:</p>
<ul>
<li>
To use an under-relaxation coefficient <code>alpha</code> when adding the heat flux into the volume.
</li>
<li>
To use the first-order upwind for <code>hOut[2]</code> and <code>hOut[nSeg]</code>. Note: Using it requires <code>nSeg>=4</code>.
</li>
</ul>
<p>
Both approaches are implemented in the model.
</p>
<p>
The model is used by
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</p>
<h4>Limitations</h4>
<p>
The model requires at least 4 fluid segments. Hence, set <code>nSeg</code> to 4 or higher.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2012 by Michael Wetter:<br/>
Removed unused protected parameters <code>sta0</code> and <code>cp0</code>.
</li>
<li>
March 29, 2012 by Wangda Zuo:<br/>
Revised the implementation to reduce the temperature overshoot.
</li>
<li>
July 28, 2010 by Wangda Zuo:<br/>
Rewrote third order upwind scheme to avoid state events.
This leads to more robust and faster simulation.
</li>
<li>
June 23, 2010 by Michael Wetter and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,66},{48,34}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,34},{48,2}},
          fillColor={166,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-48,2},{48,-64}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end ThirdOrderStratifier;
