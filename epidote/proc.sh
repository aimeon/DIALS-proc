  #!/bin/bash
  
  dials.import ../SMV/data/*.img
  dials.find_spots imported.expt exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300 d_max=9
  dials.find_rotation_axis imported.expt strong.refl 
  dials.index optimised.expt strong.refl detector.fix=distance space_group=P2
  dials.refine indexed.expt indexed.refl detector.fix=distance crystal.unit_cell.force_static=True
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300

