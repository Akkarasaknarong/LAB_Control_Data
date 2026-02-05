# Google Sheet
https://docs.google.com/spreadsheets/d/1YnXmOzDQ9pM9H3S1C0mhhm8Pv3uXedruE-_VNLvlNlY/edit?gid=386120609#gid=386120609


## MatLab setting
### Solver
- set fix-step size -> 0.0002
### Fix parameters
- motor_R = 3.69;
- motor_L = 0.04016;
### Optimization's parameters
- motor_Eff = 0.5;
- motor_Ke = 0.05;
- motor_J = 0.001;
- motor_B = 0.0001;

## Experiment setting
### Sinwave
- Run : 30 sec
- Block Parameter 
    - Amplitude : 65535
    - Frequency : 
        - 0.5 * 2 * PI
        - 1.0 * 2 * PI
        - 1.5 * 2 * PI
        - 2.0 * 2 * PI
        - 2.5 * 2 * PI
  
### Step
- Run : 20 sec
- Block Parameter
    - Step Time : 10
    - Intitial Value : 0
    - Final Value : 
        - 20% * max_PWM
        - 40% * max_PWM
        - 60% * max_PWM
        - 80% * max_PWM
        - 100% * max_PWM
### Ramp
- Run : 20 sec
- Block Parameter  
    - Slope
        - 5% * max_PWM
        - 10% * max_PWM
        - 15% * max_PWM
        - 20% * max_PWM
        - 25% * max_PWM
    - Start Time : 2 Sec

### Stair
- Run : 25 sec
- Block Name : Stair Generator (Because have more type)
- Block Parameter :
    - Time : [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]
    - Amplitude : [0 0.1 0 0.2 0 0.3 0 0.4 0 0.5 0 0.6 0 0.7 0 0.8 0 0.9 0 1]

### Chirp
- Run : 45 sec
- Block Parameter :
    - Intitial frequency : 0 Hz
    - Target Time : 
        - 20 sec
        - 25 sec
        - 30 sec
        - 35 sec    
        - 40 sec
    - Frequency at target time : 2 Hz