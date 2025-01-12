///|
struct Module {
  npcs : MapNpcs
  container : &@ui.Container
  get_player_name : () -> String
  util_dlg_ex : @resource.NxNode
  packet_processor : @net.PacketProcessor
}

///|
pub fn Module::load(
  container : &@ui.Container,
  get_player_name : () -> String,
  packet_processor : @net.PacketProcessor
) -> @utils.Future[Module] {
  @ui.ui_window_2_loader().load_res(["UtilDlgEx"])
  |> @utils.map(fn(it) {
    Module::new(container, get_player_name, it, packet_processor)
  })
}

///|
fn Module::new(
  container : &@ui.Container,
  get_player_name : () -> String,
  util_dlg_ex : @resource.NxNode,
  packet_processor : @net.PacketProcessor
) -> Module {
  let npcs = MapNpcs::new(
    fn(attrs) {
      @ui.Element::new(
        fn(hooks) {
          let ui = new_npc_talk_ui(
            hooks, util_dlg_ex, container, packet_processor,
          )
          ui
          .change_text?(
            attrs.npcid,
            attrs.msgtype,
            attrs.style_b0,
            attrs.style_b1,
            attrs.speakerbyte,
            attrs.tx,
            attrs.player_name,
          )
          .unwrap()
          ui
        },
        @ui.UIElementType::NPC_TALK,
      )
    },
    container,
    get_player_name,
    packet_processor,
  )
  { npcs, container, get_player_name, util_dlg_ex, packet_processor }
}

///|
pub fn make_handlers(
  self : Module
) -> Map[@net.Opcode, (@net.InPacket) -> Unit] {
  [
    @net.make_handler(@net.SPAWN_NPC, parse_spawn_npc, fn(npc) {
      handle_spawn_npc_parsed(self.npcs, npc)
    }),
    @net.make_handler(@net.SPAWN_NPC_C, parse_spawn_npc_controller, fn(
      ctrl : SpawnNpcController
    ) {
      handle_spawn_npc_controller_parsed(self.npcs, ctrl)
    }),
    @net.make_handler(@net.NPC_DIALOGUE, parse_npc_dialogue, fn(
      dialogue : NpcDialogue
    ) {
      handle_npc_dialogue_parsed(
        self.container,
        self.get_player_name,
        self.util_dlg_ex,
        self.packet_processor,
        dialogue,
      )
    }),
  ]
  |> Map::from_array
}

///|
pub fn get_npcs(self : Module) -> MapNpcs {
  self.npcs
}

///|
pub fn parse_spawn_npc(recv : @net.InPacket) -> NpcSpawn! {
  let oid = recv.read_int!()
  let id = recv.read_int!()
  let position = recv.read_point!()
  let flip = recv.read_bool!()
  let fh = recv.read_ushort!()
  recv.read_short!() |> ignore // 'rx'
  recv.read_short!() |> ignore // 'ry'
  { oid, id, position, flip, fh }
}

///|
pub fn handle_spawn_npc_parsed(npcs : MapNpcs, npc : NpcSpawn) -> Unit {
  npcs.spawn(npc)
}

///|
pub struct SpawnNpcController {
  mode : Int
  oid : Int
  npc : NpcSpawn?
} derive(Show, ToJson)

///|
pub fn parse_spawn_npc_controller(recv : @net.InPacket) -> SpawnNpcController! {
  let mode = recv.read_byte!()
  let oid = recv.read_int!()
  let npc = if mode == 0 {
    None
  } else {
    let id = recv.read_int!()
    let position = recv.read_point!()
    let flip = recv.read_bool!()
    let fh = recv.read_ushort!()
    recv.read_short!() |> ignore // 'rx'
    recv.read_short!() |> ignore // 'ry'
    recv.read_bool!() |> ignore // 'minimap'
    Some({ oid, id, position, flip, fh })
  }
  { mode, oid, npc }
}

///|
pub fn handle_spawn_npc_controller_parsed(
  npcs : MapNpcs,
  ctrl : SpawnNpcController
) -> Unit {
  if ctrl.mode == 0 {
    npcs.remove(ctrl.oid)
  } else {
    npcs.spawn(ctrl.npc.unwrap())
  }
}

///|
pub struct NpcDialogue {
  npcid : Int
  msgtype : Int
  speaker : Int
  text : String
  style_b0 : Int
  style_b1 : Int
} derive(Show, ToJson)

///|
pub fn parse_npc_dialogue(recv : @net.InPacket) -> NpcDialogue! {
  recv.skip!(1)
  let npcid = recv.read_int!()
  let msgtype = recv.read_byte!() // 0 - textonly, 1 - yes/no, 4 - selection, 12 - accept/decline
  let speaker = recv.read_byte!()
  let text = recv.read_string!()
  let (style_b0, style_b1) = if recv.available() && msgtype == 0 {
    // {b0, b1}
    // {0, 1} = next
    // {1, 0} = prev
    // {1, 1} = nextPrev
    // {0, 0} = ok
    (recv.read_ubyte!(), recv.read_ubyte!())
  } else {
    (0, 0)
  }
  { npcid, msgtype, speaker, text, style_b0, style_b1 }
}

///|
pub fn handle_npc_dialogue_parsed(
  container : &@ui.Container,
  get_player_name : () -> String,
  util_dlg_ex : @resource.NxNode,
  packet_processor : @net.PacketProcessor,
  dialogue : NpcDialogue
) -> Unit {
  container.add_ui(
    @ui.Element::new(
      fn(hooks) {
        let ui = new_npc_talk_ui(
          hooks, util_dlg_ex, container, packet_processor,
        )
        ui
        .change_text?(
          dialogue.npcid,
          dialogue.msgtype,
          dialogue.style_b0,
          dialogue.style_b1,
          dialogue.speaker,
          dialogue.text,
          get_player_name(),
        )
        .unwrap() // TODO: handle error
        ui
      },
      @ui.UIElementType::NPC_TALK,
    ),
    UINpcTalk::const_focused(),
  )
}

///|
fn new_npc_talk_ui(
  hooks : @ui.Hooks,
  util_dlg_ex : @resource.NxNode,
  container : &@ui.Container,
  packet_processor : @net.PacketProcessor
) -> UINpcTalk {
  UINpcTalk::new(NpcTalkResource::from_resource(util_dlg_ex), hooks, on_choice=fn(
    c
  ) {
    container.remove_ui(@ui.UIElementType::NPC_TALK)
    packet_processor.send_packet(make_choice_packet(c))
  })
}
