/* Maze
 * Author: acer
 * Creation date: 1/6/2023
 */
MACHINE
    Maze
    
CONSTANTS
    maze_x_range,
    maze_y_range,
    maze,
    internal_walls,
    entry_square,
    exit_square
    
PROPERTIES
    
    maze_x_range <: NATURAL1 & maze_x_range = 1..7 &  //The x-axis range is limited to 1-7.
    
    maze_y_range <: NATURAL1 & maze_y_range = 1..5 & //The y-axis range is limited to 1-5.
    
    maze : maze_x_range <-> maze_y_range & // maze is the relation between x-axis range and the y-axis range (x |-> y)
    
    maze = maze_x_range * maze_y_range & // maze is formed by taking the Cartesian product of the x- and y-axis ranges ({1..7} * {1..5})
    
    internal_walls : maze_x_range <-> maze_y_range & // internal_walls is relation between x-axis range and the y-axis range (x |-> y)
    
    // Creating the internal walls in the maze
    internal_walls = {
        (2 |-> 1), (6 |-> 1), (4 |-> 2), (6 |-> 2), (1 |-> 3), (2 |-> 3), (3 |-> 3), (4 |-> 3), (4 |-> 4), (6 |-> 4), (7 |-> 4), (2 |-> 5)
    } &
    
    //  Creating the entry and exit squares
    entry_square : maze_x_range <-> maze_y_range &
    entry_square = {(1 |-> 1)} &
    exit_square : maze_x_range <-> maze_y_range &
    exit_square = {(1 |-> 5)}
    
END