///|
pub fn remove_if[T](array : Array[T], f : (T) -> Bool) -> Unit {
  array.retain(fn(item) { f(item).not() })
}
