struct Bullet {
  animation : @utils.Future[@graphics.Animation]
  move_obj : @physics.MovingObject
  mut flip : Bool
}

pub fn Bullet::new(
  animation : @utils.Future[@graphics.Animation],
  origin : @struct.Point[Int],
  toleft : Bool
) -> Bullet {
  let move_obj = @physics.MovingObject::default()
  move_obj.set_x(origin.x.to_double() + (if toleft { -30.0 } else { 30.0 }))
  move_obj.set_y(origin.y.to_double() - 26.0)
  { animation, move_obj, flip: toleft }
}

pub fn draw(
  self : Bullet,
  viewx : Double,
  viewy : Double,
  alpha : Double
) -> Unit {
  guard let Some(animation) = self.animation.poll() else { None => return  }
  let bulletpos = self.move_obj.get_absolute(viewx, viewy, alpha)
  let args = @graphics.DrawArgument::new14(bulletpos, self.flip)
  animation.draw(args, alpha)
}

pub fn update(self : Bullet, target : @struct.Point[Int]) -> Bool {
  match self.animation.poll() {
    None => ()
    Some(animation) => animation.update() |> ignore
  }
  self.move_obj.move()
  let xdelta = target.x - self.move_obj.get_x()
  if self.move_obj.hspeed > 0.0 {
    xdelta < 10
  } else {
    xdelta > 10
  }
}

pub fn set_target(self : Bullet, target : @struct.Point[Int]) -> Bool {
  let xdelta = target.x - self.move_obj.get_x()
  let ydelta = target.y - self.move_obj.get_y()
  if xdelta.abs() < 10 {
    return true
  }
  self.flip = xdelta > 0
  self.move_obj.hspeed = xdelta.to_double() / 32.0
  if xdelta > 0 {
    if self.move_obj.hspeed < 3.0 {
      self.move_obj.hspeed = 3.0
    } else if self.move_obj.hspeed > 6.0 {
      self.move_obj.hspeed = 6.0
    }
  } else if xdelta < 0 {
    if self.move_obj.hspeed > -3.0 {
      self.move_obj.hspeed = -3.0
    } else if self.move_obj.hspeed < -6.0 {
      self.move_obj.hspeed = -6.0
    }
  }
  self.move_obj.vspeed = self.move_obj.hspeed *
    ydelta.to_double() /
    xdelta.to_double()
  return false
}
