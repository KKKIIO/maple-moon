///|
struct Mod {
  mode : Modification
  t : TypeId
  pos : Int
  arg : Int
}

///|
fn handle_modify_inventory(
  inventory : Inventory,
  player_getter : () -> @player.Player?,
  recv : @net.InPacket
) -> Unit! {
  guard let Some(player) = player_getter() else { None => return }
  recv.read_bool!() |> ignore // 'updatetick'
  let mods = Array::new()
  let size = recv.read_byte!()
  for i in 0..<size {
    let mut mode = recv.read_byte!() |> Modification::from_int |> Option::unwrap
    let t = TypeId::by_value(recv.read_byte!()) |> Option::unwrap
    let pos = recv.read_short!()
    let mut arg = 0
    match mode {
      Modification::ADD => parse_item!(recv, t, pos, inventory)
      Modification::CHANGE_COUNT => {
        arg = recv.read_short!()
        let count_before = inventory.get_item_count(t, pos)
        let count_now = arg
        inventory.modify(t, pos, mode, arg, Movement::MOVE_NONE)
        if count_before < count_now {
          mode = Modification::ADD_COUNT
        }
      }
      Modification::SWAP => arg = recv.read_short!()
      Modification::REMOVE =>
        inventory.modify(t, pos, mode, arg, Movement::MOVE_INTERNAL)
      _ => ()
    }
    mods.push({ mode, t, pos, arg })
  }
  let mov = if recv.available() {
    Movement::from_int(recv.read_byte!()).unwrap()
  } else {
    Movement::MOVE_INTERNAL
  }
  for mod in mods {
    if mod.mode == Modification::SWAP {
      inventory.modify(mod.t, mod.pos, mod.mode, mod.arg, mov)
    }

    // TODO: shop

    match mov {
      Movement::MOVE_INTERNAL =>
        match mod.t {
          TypeId::EQUIPPED => {
            // TODO: ui
            change_equip(inventory, player, -mod.pos)
            change_equip(inventory, player, -mod.arg)
          }
          TypeId::EQUIP
          | TypeId::USE
          | TypeId::SETUP
          | TypeId::ETC
          | TypeId::CASH => ()
        }
      Movement::MOVE_EQUIP | Movement::MOVE_UNEQUIP =>
        if mod.pos < 0 {
          change_equip(inventory, player, -mod.pos)
        } else if mod.arg < 0 {
          change_equip(inventory, player, -mod.arg)
        }
      _ => ()
    }
  }
  player.recalc_stats(true)
}

///|
fn change_equip(
  inventory : Inventory,
  player : @player.Player,
  raw_slot_id : Int
) -> Unit {
  let slot = @slot.Id::from_int(raw_slot_id)
  match inventory.get_item_id(TypeId::EQUIPPED, raw_slot_id) {
    0 => player.character.get_look().remove_equip(slot)
    itemid => player.character.get_look().add_equip(itemid, slot)
  }
}
