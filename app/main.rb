DEBUG = false
GRID_SIZE = 20
SPEED = 20

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
  move_snake(args) if args.tick_count.mod_zero? SPEED
end

def render(args)
  render_debug_info(args)
  render_grid(args)
  render_snake(args)
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

def default(args)
  args.state.head ||= {
    x: args.grid.w / 2,
    y: args.grid.h / 2,
    w: GRID_SIZE,
    h: GRID_SIZE,
    r: 23,
    g: 245,
    b: 23
  }
end

def tick(args)
  default(args)
  handle_input(args)
  update(args)
  render(args)
end
