GRID_SIZE = 20

def handle_input(args); end

def update(args); end

def render(args)
  render_debug_info(args)
  render_grid(args)
end

def render_grid(args); end

def render_debug_info(args)
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

def tick(args)
  handle_input(args)
  update(args)
  render(args)
end
