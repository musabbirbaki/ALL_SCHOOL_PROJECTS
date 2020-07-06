# Graphics_Final_Project
## Members: Kabilan Manogaran and Musabbir Baki

### All programming was done as a pair.

#### This project was done with the help of Randy Fortier, through the code examples that he created in class and provided in https://github.com/randyfortier/CSCI3090U_Examples. 

For our project we have created a game where the goal is to move your player model (a snowman)
and get it to collide with a moving "enemy" model (currently a gold cylinder). 

- The ground is the xz plane. 
- The player model can be moved by dragging while holding down the right mouse button. 
    - Dragging the mouse directly downwards will move you along the positive z axis, while dragging it directly upwards will move you along the negative z axis.
    - Dragging the mouse directly to the left will move you along the positive x axis, while dragging it directly to the right will move you along the negative x axis. 
- Pressing r will reset the game, it may take a little bit of time due to the ground texture being re-applied. Ground textures with lower resolutions will result in the reset occurring faster. 

The enemy pathing is currently set to 4 points in a square shape. Its pathing can be easily changed by adjusting its points and the number of hops (which must be equal to the number of points). Enemy pathing variables and definition can be found by using ctrl + f and searching for ENEMY BEZIER PATH.