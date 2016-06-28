within Annex60.Fluid.Storage.Validations;
model Experiment5
  extends Experiment1(
    combiTimeTable(fileName=classDirectory()+"/data/exp_5.mat"),
    tan(
      vol(T_start={286.155, 286.155, 286.919, 288.584, 290.249, 291.913, 293.578, 293.939, 294.042, 294.426, 294.810, 295.193, 295.577, 295.708, 295.708, 295.747, 295.787, 295.826, 295.865, 295.869, 295.843, 295.860, 295.877, 295.895, 295.912, 295.947, 296.010, 296.061, 296.111, 296.162, 296.212, 296.234, 296.181, 296.301, 296.451, 296.602, 296.753, 296.963, 297.506, 298.839, 300.473, 302.108, 303.742, 305.470, 310.171, 312.894, 314.308, 315.722, 315.939, 316.012})));
  annotation (experiment(StopTime=600), __Dymola_experimentSetupOutput(events=
          false));
end Experiment5;
