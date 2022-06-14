# Fan-Beam-CT Algebraic Reconstruction Techniques
# EE519 Medical Imaging Project
The developed code here is forked from this [repo](https://github.com/kutay-ugurlu/Parallel-Beam-Computerized-Tomography-Simulation).

## Graphical User Interface
### Usage
![GUI](https://user-images.githubusercontent.com/83376963/173533237-c19c14d8-b3f0-4fb1-b3f1-0200baecb720.png)

#### Projection
* The interface requires the phantom path input as relative input to the MATLAB app directory. 
* Set the required parameters numerically.
* Press the <ins>PROJECT</ins> button.

#### Reconstruction 
* After the projection step is complete, the projection data is stored in the current working directory.
* The reconstruction utilizing all 4 algorithms is automatically started after projection.

| :warning: INFO & WARNINGS  |
|:---------------------------|
| Use "." for decimal seperator. | 
| Checking the __Delete Projections when quitting__ box will delete all the available projections generated while the app runs. Make sure to uncheck it if you want to reuse them.| 
| Checking the __Show the RE-wise best image__ box will show the output of current iteration until [early_stopper.m](https://github.com/kutay-ugurlu/Fan-Beam-CT-ART-Simulation/blob/master/early_stopper.m) terminates the function. Then the program will show the output of the iteration whose output minimizes the [reconstruction error](https://github.com/kutay-ugurlu/Fan-Beam-CT-ART-Simulation/blob/master/reconstruction_error.m) for the previous iterations.| 

### An example tutorial 
![GUI Example](https://user-images.githubusercontent.com/83376963/173532960-b99679cd-58b5-44c5-8b3f-385e907981eb.png)
