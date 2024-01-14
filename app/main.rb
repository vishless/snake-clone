GRID_SIZE = 20

def handle_input(args); end

def update(args); end

def render(args)
  render_debug_info(args)
  render_grid(args)
end

def render_grid(args); end

def render_debug_info(args)
  args.outputs.labels << [60, 600, "Width: #{args.grid.w}", 1, 1]
  args.outputs.labels << [60, 570, "Height: #{args.grid.h}", 1, 1]
end

def tick(args)
  handle_input(args)
  update(args)
  render(args)
end
