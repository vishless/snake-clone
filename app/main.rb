DEBUG = false
GRID_SIZE = 20
SPEED = 5

def handle_input(args)
  inputs = args.inputs
  head = args.state.head

  head.direction = :left if inputs.left
  head.direction = :right if inputs.right
  head.direction = :up if inputs.up
  head.direction = :down if inputs.down
end

def move_snake(args)
  head = args.state.head
  vector = { x: 0, y: 0 }

  case head.direction
  when :right
    vector.x = 1
  when :left
    vector.x = -1
  when :up
    vector.y = 1
  when :down
    vector.y = -1
  end

  head.x += GRID_SIZE * vector.x
  head.y += GRID_SIZE * vector.y
end

def update(args)
  return unless args.tick_count.mod_zero?(SPEED)

  move_snake(args)
  handle_boundary_collision(args)
  spawn_collectable(args)
end

def spawn_collectable(args)
  return unless args.state.collectable.nil?

  x_rand = rand_ceil(args.grid.w)
  y_rand = rand_ceil(args.grid.h)

  args.state.collectable = {
    x: x_rand * GRID_SIZE,
    y: y_rand * GRID_SIZE,
    h: GRID_SIZE,
    w: GRID_SIZE,
    r: 233, g: 23, b: 23
  }
end

def rand_ceil(length)
  ((length / GRID_SIZE) - 2).randomize(:ratio).ceil
end

def render(args)
  render_debug_info(args)
  render_grid(args)
  render_snake(args)
  render_walls(args)
  render_collectable(args)
end

def render_collectable(args)
  args.outputs.solids << args.state.collectable
end

def render_grid(args)
  x_axis = args.grid.w / GRID_SIZE
  y_axis = args.grid.h / GRID_SIZE

  x_axis.each do |x|
    args.outputs.lines << {
      x: x * GRID_SIZE,
      y: 0,
      x2: x * GRID_SIZE,
      y2: args.grid.h
    }
  end

  y_axis.each do |y|
    args.outputs.lines << {
      x: 0,
      y: y * GRID_SIZE,
      x2: args.grid.w,
      y2: y * GRID_SIZE
    }
  end
end

def render_walls(args)
  walls = args.state.walls
  args.outputs.solids << [walls.left, walls.right, walls.top, walls.bottom]
end

def render_snake(args)
  args.outputs.solids << args.state.head
end

# TODO: Move render_debug_info to a separate class
def render_debug_info(args)
  return unless DEBUG

  args.outputs.labels << { x: 100,
                           y: 600,
                           text: "args.grid.w: #{args.grid.w}",
                           alignment_enum: 3,
                           r: 0, g: 0, b: 255, a: 75 }

  args.outputs.labels << { x: 100,
                           y: 570,
                           text: "args.grid.h: #{args.grid.h}",
                           alignment_enum: 3,
                           r: 0, g: 0, b: 255, a: 75 }
end

def handle_boundary_collision(args)
  walls = args.state.walls
  head = args.state.head

  if [walls.left, walls.right, walls.top, walls.bottom].any_intersect_rect?(args.state.head)
    head.x = head.x.clamp(walls.left.right, walls.right.left - GRID_SIZE)
    head.y = head.y.clamp(walls.bottom.top, walls.top.bottom - GRID_SIZE)
  end
end

def default(args)
  args.state.head ||= {
    x: args.grid.w / 2,
    y: args.grid.h / 2,
    w: GRID_SIZE,
    h: GRID_SIZE,
    r: 23, g: 245, b: 23
  }
  args.state.walls.left ||= {
    x: args.grid.left,
    y: args.grid.bottom,
    h: args.grid.h,
    w: GRID_SIZE,
    r: 12, g: 33, b: 245
  }
  args.state.walls.right ||= {
    x: args.grid.right - GRID_SIZE,
    y: args.grid.bottom,
    h: args.grid.h,
    w: GRID_SIZE,
    r: 12, g: 33, b: 245
  }
  args.state.walls.top ||= {
    x: args.grid.left,
    y: args.grid.top - GRID_SIZE,
    h: GRID_SIZE,
    w: args.grid.w,
    r: 12, g: 33, b: 245
  }
  args.state.walls.bottom ||= {
    x: args.grid.left,
    y: args.grid.bottom,
    h: GRID_SIZE,
    w: args.grid.w,
    r: 12, g: 33, b: 245
  }
end

def tick(args)
  default(args)
  handle_input(args)
  update(args)
  render(args)
end
