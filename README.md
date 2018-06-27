# Mario Kart - The Famous game created with Cellulo robots

**Game created by Antoine TRAN**

## Information



- **Language** : Qt Modelling Language (QML) 5.9

- **Build System** : QMake

- **Library** : Cellulo 1.0

## Set up

- The Robot control panel is necessary to connect your robot

- Use the scanner button, then select the adress of your robot, finally click connect

- Place the robot on the map

- Choose your map. You are free to add as many as you want, this version contains only one

- As soon as the robot's lights are green, you can press the "Play" button

## Controls

The purpose of this 2D Game is to reach three times the end of the circuit. To move and rotate the robot, let's see how the pannel works :

- The circle at the bottom left of the screen helps moving the robot. Place a finger around the circle, the angle will be calculated and the robot will move in the right direction. The further from the center of the circle you are, the faster the robot will move

- The two arrows at the bottom right are used to rotate the robot. We'll se later the utility of rotating the robot

- The bonus image at the center of the screen can be used once, to avoid the required rotation of the robot. Again, we'll se later why this is useful

- The "I am stuck" button shouldn't be used. Ifyou can't move your robot despite the fact that all the leds are green, this means a bug appeared, so you can unlock the robot with this button

- The Red / Green Rectangle shows either the robot is kidnapped or not

## GamePlay

- Every 12 seconds, a blue led will appear. A timer is represented by the red leds that will appear, and you have to point the blue led towards the north of the map before all the leds become red, otherwise you will get stuck during a period of 3 seconds

- You can also notice coins and mushrooms on the circuit. You can only take these bonus once per round.
Both give you points at the end of the race, and in addition the mushrooms increases your speed during 5 seconds of 66%

- Each map contains checkpoints, as soon as you cross the border of the road the robot will be moved to the last checkpoint

## Score calculation

Your initial score is 100. After 4 minutes, you start loosing 1 point every 4 seconds, and each bonus gives you one point back. Assuming that you should normally take between 6 and 10 minutes to finish the race, according with the approximation that you can take 6 bonus per round, with a total of 18 back points, your score should be between 20 and 80.
