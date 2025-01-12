struct Window {
  ui : UI
  opacity : Double
  get_now : () -> @utils.TimePoint
  mut last_click : @utils.TimePoint
}

fn Window::new(ui : UI, get_now : () -> @utils.TimePoint) -> Window {
  { ui, opacity: 1.0, last_click: @utils.TimePoint::default(), get_now }
}

fn begin(self : Window) -> Unit {
  @graphics.GraphicsGL::get().clear_scene()
}

fn end(self : Window) -> Unit {
  @graphics.GraphicsGL::get().flush(self.opacity)
}

pub fn onmousemove(self : Window, x : Int, y : Int) -> Unit {
  self.ui.send_cursor_pos({ x, y })
}

pub fn onmouseup(self : Window) -> Unit {
  self.ui.send_cursor_pressed(false)
}

pub fn onmousedown(self : Window) -> Unit {
  let now = (self.get_now)()
  let diff_ms = now.since(self.last_click).to_milliseconds()
  self.last_click = now
  if diff_ms > 10 && diff_ms < 200 {
    self.ui.doubleclick()
  }
  self.ui.send_cursor_pressed(true)
}

// fn fadeout(self : Window, step : Double, fadeproc : () -> Unit) -> Unit {
//   fadeproc()
// }
pub fn key_callback(self : Window, keyCode : String, pressed : Bool) -> Unit {
  self.ui.send_key(keyCode, pressed)
}
