/* Robot
 * Author: acer
 * Creation date: 1/6/2023
 */
 

MACHINE
    Robot
    
SEES
    Maze
    
SETS
    OUTPUT = {Failed_Due_To_Exceeding_Maze_Boundary, Failed_Due_To_An_Internal_Wall_Crash, Moved_North, Moved_East, Moved_South, Moved_West, Teleportation_Is_Not_Possible_In_The_First_Move, Not_Possible_To_Teleport_To_The_Same_Square_Twice, Teleported, yes, no, Reset_Is_Done, Exit_Square_Has_Found}
   
    
VARIABLES
    X_position_of_robot,
    Y_position_of_robot,
    robot_current_position,
    visited_squares_in_maze
    
INVARIANT
    X_position_of_robot : maze_x_range &
    Y_position_of_robot : maze_y_range &
    robot_current_position : maze &
    visited_squares_in_maze : seq(maze)
    
INITIALISATION
    // Initializes all the position related variables by assigning (1, 1) as the initial square
    X_position_of_robot := 1 ||
    Y_position_of_robot := 1 ||
    robot_current_position := ( 1 |-> 1 ) ||
    visited_squares_in_maze := [( 1 |-> 1 )]
    
OPERATIONS
    
        
    //Moving robot to North 
    result <-- RobotMoveNorth = 
        PRE result : OUTPUT
        THEN
            IF ((X_position_of_robot |-> Y_position_of_robot ) : exit_square)
            THEN 
                result := Exit_Square_Has_Found
            ELSIF (Y_position_of_robot + 1 > max(maze_y_range))
            THEN 
                result := Failed_Due_To_Exceeding_Maze_Boundary
  
            ELSIF ((X_position_of_robot |-> Y_position_of_robot + 1) : internal_walls) 
                THEN 
                    result := Failed_Due_To_An_Internal_Wall_Crash
                ELSE                 
                    visited_squares_in_maze := (visited_squares_in_maze <- (X_position_of_robot |-> Y_position_of_robot + 1)) ||
                    robot_current_position := (X_position_of_robot |-> Y_position_of_robot + 1) ||
                    Y_position_of_robot := Y_position_of_robot + 1 ||
                    result := Moved_North     
            END
        END;
        
    //Moving robot to South
     result <-- RobotMoveSouth = 
        PRE result : OUTPUT
        THEN
            IF ((X_position_of_robot |-> Y_position_of_robot ) : exit_square)
            THEN 
                result := Exit_Square_Has_Found
            ELSIF ((X_position_of_robot |-> Y_position_of_robot ) : exit_square)
            THEN 
                result := Exit_Square_Has_Found
            ELSIF (Y_position_of_robot - 1 < min(maze_y_range))
            THEN 
                result := Failed_Due_To_Exceeding_Maze_Boundary
            
            ELSIF ((X_position_of_robot |-> Y_position_of_robot - 1) : internal_walls) 
            THEN 
                result := Failed_Due_To_An_Internal_Wall_Crash
            ELSE                
                visited_squares_in_maze := (visited_squares_in_maze <- (X_position_of_robot |-> Y_position_of_robot - 1)) ||
                robot_current_position := (X_position_of_robot |-> Y_position_of_robot - 1) ||
                Y_position_of_robot := Y_position_of_robot - 1 ||
                result := Moved_South
            END        
        END;
        

    //Moving robot to East 
    result <-- RobotMoveEast = 
        PRE result : OUTPUT
        THEN
            IF ((X_position_of_robot |-> Y_position_of_robot ) : exit_square)
            THEN 
                result := Exit_Square_Has_Found
            ELSIF (X_position_of_robot + 1 > max(maze_x_range))
            THEN 
                result := Failed_Due_To_Exceeding_Maze_Boundary
            
            ELSIF ((X_position_of_robot + 1 |-> Y_position_of_robot) : internal_walls) 
                THEN 
                    result := Failed_Due_To_An_Internal_Wall_Crash
                ELSE 
                    visited_squares_in_maze := (visited_squares_in_maze <- (X_position_of_robot + 1 |-> Y_position_of_robot)) ||
                    robot_current_position := (X_position_of_robot + 1 |-> Y_position_of_robot) ||
                    X_position_of_robot := X_position_of_robot + 1 ||
                    result := Moved_East
            END
        END;

    

    //Moving robot to West 
    result <-- RobotMoveWest = 
        PRE result : OUTPUT
        THEN
            IF ((X_position_of_robot |-> Y_position_of_robot ) : exit_square)
            THEN 
                result := Exit_Square_Has_Found    
            ELSIF (X_position_of_robot - 1 < min(maze_x_range))
            THEN 
                result := Failed_Due_To_Exceeding_Maze_Boundary
               
            ELSIF ((X_position_of_robot - 1 |-> Y_position_of_robot) : internal_walls) 
                THEN 
                    result := Failed_Due_To_An_Internal_Wall_Crash
                ELSE 
                    visited_squares_in_maze := (visited_squares_in_maze <- (X_position_of_robot - 1 |-> Y_position_of_robot)) ||
                    robot_current_position := (X_position_of_robot - 1 |-> Y_position_of_robot) ||
                    X_position_of_robot := X_position_of_robot - 1 ||
                    result := Moved_West
            END
        END;

   
   //Teleport
         result <-- TeleportRobotInMaze(teleport_X_Position, teleport_Y_Position) =
            PRE result : OUTPUT & teleport_X_Position : NATURAL1 & teleport_Y_Position : NATURAL1
            THEN
                
                IF ((X_position_of_robot |-> Y_position_of_robot ) : exit_square)
                THEN
                    result := Exit_Square_Has_Found
                ELSIF (size(visited_squares_in_maze) = 1) // Observes that this is not the initial move
                THEN 
                    result := Teleportation_Is_Not_Possible_In_The_First_Move
                
                ELSIF ((teleport_X_Position |-> teleport_Y_Position) : internal_walls)
                THEN 
                    result := Failed_Due_To_An_Internal_Wall_Crash
                
                ELSIF (teleport_X_Position = X_position_of_robot & teleport_Y_Position = Y_position_of_robot) // Observes that the robot does not teleport to the same current square
                THEN
                    result := Not_Possible_To_Teleport_To_The_Same_Square_Twice
               
                ELSIF ((teleport_X_Position |-> teleport_Y_Position) /: maze)
                THEN
                    result := Failed_Due_To_Exceeding_Maze_Boundary
                ELSE
                    visited_squares_in_maze := (visited_squares_in_maze <- (teleport_X_Position |-> teleport_Y_Position)) ||
                    robot_current_position := (teleport_X_Position |-> teleport_Y_Position) ||
                    X_position_of_robot := teleport_X_Position ||
                    Y_position_of_robot := teleport_Y_Position ||
                    result := Teleported
                END
            END;

    //Get current position of the robot
        position <-- GetPositionOfRobot =
            BEGIN 
            position := robot_current_position
            END;

    //check see if the robot is currently at the maze's exit square
        found <-- FoundExitOFMaze = 
            PRE found : OUTPUT
            THEN
                IF (robot_current_position : exit_square)
                THEN 
                    found := yes
                ELSE 
                    found := no
                END
            END;

    //check see if the robot has visited the given square
        visited <-- GetVisitedSquareInMaze(visited_X_Position, visited_Y_Position) =
            PRE visited : OUTPUT & visited_X_Position : NATURAL1 & visited_Y_Position : NATURAL1
            THEN
                IF ((visited_X_Position |-> visited_Y_Position) : maze)
                THEN 
                    IF ((visited_X_Position |-> visited_Y_Position) : ran(front(visited_squares_in_maze)))
                    THEN 
                        visited := yes
                    ELSE
                        visited := no
                    END
                ELSE
                    visited := Failed_Due_To_Exceeding_Maze_Boundary
                END
            END;

    
        route <-- GetRouteOfRobotInMaze =
            BEGIN
                route := visited_squares_in_maze
            END;
            
      //reinitialize the system      
        reset <-- ResetTheSystem =
            BEGIN
                X_position_of_robot := 1 ||
                Y_position_of_robot := 1 ||
                robot_current_position := ( 1 |-> 1 ) ||
                visited_squares_in_maze := [( 1 |-> 1 )] ||  
                reset := Reset_Is_Done
            END 
END
