require 'debugger'

class MazeSolver

  def initialize
    @matrix = parse_maze_file("maze1.txt")
    @start_point = find_start
    @end_point = find_end
    @height = @matrix[0].length
    @shortest_path = find_shortest_path
  end

  def parse_maze_file(file)
    # walls are 1, empty spaces are 0, start is 2, end is 3
    matrix = []
    File.open(file).each_line do |line|
      temp = []
      line.split("").each do |char|
        if char == "*"
          temp << 1
        elsif char == " "
          temp << 0
        elsif char == "S"
          temp << 2
        elsif char == "E"
          temp << 3
        end
      end
        matrix << temp
    end
    return matrix
  end

  def find_start
    @matrix.length.times do |x|
      @matrix[0].length.times do |y|
        if @matrix[x][y] == 2
          return [x,y]
        end
      end
    end
  end
        
  def find_end
    @matrix.length.times do |x|
      @matrix[0].length.times do |y|
        if @matrix[x][y] == 3
          return [x,y]
        end
      end
    end
  end

  def access(point)
    @matrix[point[0]][point[1]]
  end

  def display_matrix
    @matrix.length.times do |x|
      @matrix[0].length.times do |y|
        print @matrix[x][y]
      end
      puts ""
    end
  end

  def find_shortest_path
    #A* implementation of shortest path
    start_point_hash = {:point => @start_point, :origin => @start_point, :g => 0, :h => get_guess(@start_point), :f => get_guess(@start_point)}
    open_list = [start_point_hash]
    closed_list = []
    end_in_closed_list = false
    lowest_f_in_open = nil
    until end_in_closed_list
      #find the point in the open list with the smallest f
      open_list.sort_by!{|x|x[:g]}.reverse!
      popped = open_list.pop
      #put it in the closed list
      closed_list << popped
      #for each of the surrounding squares that's an open space
      new_points = empty_border_squares(popped[:point]).each do |point_g|
        #if it isn't in the closed list
        debugger
        if closed_list.select{|x|x[:point] == (point_g[0])} == []
          #if it isn't in the open list, add it.
          if open_list.select{|x|x[:point] == (point_g[0])} == []
            temp = {}
            temp[:point] = point_g[0]
            temp[:origin] = popped[:point]
            temp[:g] = popped[:g] + point_g[1]
            temp[:h] = get_guess(temp[:point])
            temp[:f] = temp[:g] + temp[:h]
            open_list << temp
          else
            #if this path (according to g) is better
            point_in_open_already = open_list.select{|x|x[:point] == (point_g[0])}[0]
            if point_in_open_already[:g] > popped[:g] + point_g[1]
              point_in_open_already[:origin] = popped[:point]
              point_in_open_already[:g] = popped[:g] + point_g[1]
              point_in_open_already[:f] = point_in_open_already[:h] + point_in_open_already[:g]
            end
          end
        end
      end
      closed_list.each do |hash|
        if hash[:point] == @end_point
          end_in_hash_closed_list = true
        end
      end        
    end
    return closed_list
  end

  def get_guess(point)
    #returns manhattan distance
    (@end_point[0]-point[0]).abs + (@end_point[1]-point[1]).abs
  end

  def empty_border_squares(point)
    points = []

    up = [point[0]-1,point[1]]
    if (point[0]-1).between?(0,@height) and is_empty(up) 
      points << [up,10]
    end
    
    down = [point[0]+1,point[1]]
    if (point[0]+1).between?(0,@height) and is_empty(down)
      points << [down,10]
    end

    left = [point[0],point[1]-1]
    if (point[1]-1).between?(0,@height) and is_empty(left)
      points << [left,10]
    end

    right = [point[0],point[1]+1]
    if (point[1]+1).between?(0,@height) and is_empty(right)
      points << [right,10]
    end
    
    upleft = [point[0]-1,point[1]-1]
    if (point[0]-1).between?(0,@height) and (point[1]-1).between?(0,@height) and is_empty(upleft)
      points << [upleft,14]
    end

    upright = [point[0]-1,point[1]+1]
    if (point[0]-1).between?(0,@height) and (point[1]+1).between?(0,@height) and is_empty(upright)
      points << [upright,14]
    end

    downleft = [point[0]+1,point[1]-1]
    if (point[0]+1).between?(0,@height) and (point[1]-1).between?(0,@height) and is_empty(downleft)
      points << [downleft,14]
    end

    downright = [point[0]+1,point[1]+1]
    if (point[0]+1).between?(0,@height) and (point[1]+1).between?(0,@height) and is_empty(downright)
      points << [downright,14]
    end

    points
  end

  def is_empty(point)
    access(point) == 0
  end

end

m = MazeSolver.new
m.display_matrix
p m.find_start
p m.find_end
