///|
struct ExplorerCreatorUI {
  model : @ui.UIModel
  resource : ExplorerCreatorUIResource
  randomizer : @utils.Randomizer
  settings : LookSettingState
  mut gender_selected : Bool
  mut charset_selected : Bool
  mut char_look_hook : (LookSettingState, @char_look.CharLook)?
  cloud_ui : CloudUI
  hooks : @ui.Hooks
  load_char_look_async : (@char_look.LookEntry, (@char_look.CharLook) -> Unit) -> Unit
  on_create_char : (NewCharacterSettings) -> Unit
}

///|
struct LookSettingState {
  mut female : Bool
  mut skin_idx : Int
  mut hair_color_idx : Int
  mut face_idx : Int
  mut hair_idx : Int
  mut top_idx : Int
  mut bot_idx : Int
  mut shoe_idx : Int
  mut weapon_idx : Int
} derive(Default, Eq)

///|
struct NewCharacterSettings {
  name : String
  job : Int
  female : Bool
  skin_id : Int
  hair_color_id : Int
  face_id : Int
  hair_id : Int
  top_id : Int
  bot_id : Int
  shoe_id : Int
  weapon_id : Int
} derive(Default)

///|
pub(all) struct ExplorerCreatorUIResource {
  male_choices : LookChoices
  female_choices : LookChoices
  sky : @graphics.Texture
  cloud : @graphics.Texture
  nameboard : @graphics.Texture
  board_gender_top : @graphics.Animation
  board_gender_mid : @graphics.Animation
  board_gender_bottom : @graphics.Animation
  board_char_set : @graphics.Animation
  back14 : @graphics.Animation
  signboard2 : @graphics.Animation
  bt_gender_male : @ui.MapleButtonResource
  bt_gender_female : @ui.MapleButtonResource
  bt_left : @ui.MapleButtonResource
  bt_right : @ui.MapleButtonResource
  bt_yes : @ui.MapleButtonResource
  bt_no : @ui.MapleButtonResource
  avatar_sel : Array[@graphics.Animation]
}

///|
pub(all) struct LookChoices {
  skins : Array[Int]
  haircolors : Array[Int]
  faces : Array[Int]
  hairs : Array[Int]
  tops : Array[Int]
  bots : Array[Int]
  shoes : Array[Int]
  weapons : Array[Int]
}

///|
pub fn ExplorerCreatorUIResource::load() ->
     @utils.Future[ExplorerCreatorUIResource] {
  let look_res_fut = get_etc_loader()
    .load_res(["MakeCharInfo.img", "Info"])
    .map(fn(mkinfo) {
      // for f, char in [(true, mkinfo["CharFemale"])(false, mkinfo["CharMale"])] {
      fn parse_choices(char : @resource.NxNode) -> LookChoices {
        let faces = []
        let hairs = []
        let haircolors = []
        let skins = []
        let tops = []
        let bots = []
        let shoes = []
        let weapons = []
        for name, node in char {
          let num = @strconv.parse_int?(name).unwrap()
          for _, idnode in node {
            let value = idnode.get_int?().unwrap()
            match num {
              0 => faces.push(value)
              1 => hairs.push(value)
              2 => haircolors.push(value)
              3 => skins.push(value)
              4 => tops.push(value)
              5 => bots.push(value)
              6 => shoes.push(value)
              7 => weapons.push(value)
              _ => ()
            }
          }
        }
        { faces, hairs, haircolors, skins, tops, bots, shoes, weapons }
      }

      (parse_choices(mkinfo["CharMale"]), parse_choices(mkinfo["CharFemale"]))
    })
  let login_loader = @ui.common_ui_loader()
  let map001_loader = get_map001_loader()
  // let common_src = login_loader.load_res(["Login.img", "Common"])
  let customize_char_src = login_loader.load_res([
    "Login.img", "CustomizeChar", "000",
  ])
  let signboard2_src_fut = get_map_latest_loader().load_res([
    "Obj", "login.img", "NewChar", "signboard", "2",
  ])
  let board_src = customize_char_src["board"]
  let gender_select_src = customize_char_src["genderSelect"]
  let sky_src_fut = map001_loader.load_res(["Back", "login.img", "back", "2"])
  let sky_fut = sky_src_fut.map(fn(src) {
    @graphics.Texture::from_resource(src)
  })
  let cloud_src_fut = map001_loader.load_res(["Back", "login.img", "back", "27"])
  let cloud_fut = cloud_src_fut.map(fn(src) {
    @graphics.Texture::from_resource(src)
  })
  let back14_src_fut = map001_loader.load_res([
    "Back", "login.img", "back", "14",
  ])
  let back14_fut = back14_src_fut.map_exn(fn(src) {
    @graphics.Animation::from_resource_ex!(src)
  })
  let signboard2_fut = signboard2_src_fut.map_exn(fn(src) {
    @graphics.Animation::from_resource_ex!(src)
  })
  let board_gender_top = @graphics.Animation::from_resource_ex?(
    board_src["genderTop"],
  ).unwrap()
  let board_gender_mid = @graphics.Animation::from_resource_ex?(
    board_src["boardMid"],
  ).unwrap()
  let board_gender_bottom = @graphics.Animation::from_resource_ex?(
    board_src["boardBottom"],
  ).unwrap()
  let board_char_set = @graphics.Animation::from_resource_ex?(
    customize_char_src["charSet"],
  ).unwrap()
  let nameboard = customize_char_src["charName"]
    |> @graphics.Texture::from_resource
  let bt_gender_male = @ui.MapleButtonResource::from_resource(
    gender_select_src["male"],
  )
  let bt_gender_female = @ui.MapleButtonResource::from_resource(
    gender_select_src["female"],
  )
  let bt_left = @ui.MapleButtonResource::from_resource(
    customize_char_src["BtLeft"],
  )
  let bt_right = @ui.MapleButtonResource::from_resource(
    customize_char_src["BtRight"],
  )
  let bt_yes = @ui.MapleButtonResource::from_resource(
    customize_char_src["BtYes"],
  )
  let bt_no = @ui.MapleButtonResource::from_resource(customize_char_src["BtNo"])
  let avatar_sel = []
  for i = 0; i <= 5; i = i + 1 {
    avatar_sel.push(
      @graphics.Animation::from_resource_ex?(
        customize_char_src["avatarSel"][i.to_string()]["normal"],
      ).unwrap(),
    )
  }
  look_res_fut
  .combine(sky_fut)
  .combine(cloud_fut)
  .combine(back14_fut)
  .combine(signboard2_fut)
  .map_exn(fn(it) {
    let (((((male_choices, female_choices), sky), cloud), back14), signboard2) = it
    let back14 = back14.unwrap_or_error!()
    let signboard2 = signboard2.unwrap_or_error!()
    {
      male_choices,
      female_choices,
      sky,
      cloud,
      board_gender_top,
      board_gender_mid,
      board_gender_bottom,
      board_char_set,
      back14,
      signboard2,
      bt_gender_male,
      bt_gender_female,
      bt_left,
      bt_right,
      bt_yes,
      bt_no,
      avatar_sel,
      nameboard,
    }
  })
  .map(fn(it) {
    it.unwrap() // TODO
  })
}

///|
pub fn ExplorerCreatorUI::new(
  resource : ExplorerCreatorUIResource,
  hooks : @ui.Hooks,
  load_char_look_async : (@char_look.LookEntry, (@char_look.CharLook) -> Unit) -> Unit,
  on_create_char~ : (NewCharacterSettings) -> Unit = fn(_v) {  }
) -> ExplorerCreatorUI {
  let gender = false
  let randomizer = @utils.Randomizer::default()
  let settings = rand_char_look(gender, randomizer, resource)
  {
    resource,
    model: @ui.UIModel::new(
      @struct.Point::new(0, 0),
      @struct.Point::new(800, 600),
    ),
    settings,
    gender_selected: gender,
    charset_selected: false,
    cloud_ui: { texture: resource.cloud, x: 200.0 },
    char_look_hook: None,
    hooks,
    randomizer,
    load_char_look_async,
    on_create_char,
  }
}

///|
pub impl @ui.UIElement for ExplorerCreatorUI with render(self) -> @ui.RenderSpec {
  self.load_char_look()
  let render_units : Array[&@ui.RenderUnit] = []
  render_units.push(
    @ui.SpriteUI(
      @graphics.Sprite::new(
        self.resource.back14,
        @graphics.DrawArgument::new(pos=@struct.Point::new(250, 302)),
      ),
    ),
  )
  render_units.push(
    @ui.SpriteUI(
      @graphics.Sprite::new(
        self.resource.signboard2,
        @graphics.DrawArgument::new_scale(
          position=@struct.Point::new(234, 235),
          scale=2.0,
        ),
      ),
    ),
  )
  render_units.push(
    @graphics.TileUnit::new(
      self.resource.sky,
      rows=2,
      cols=(800.0 / self.resource.sky.width().to_double()).ceil().to_int(),
      row_height=400,
      col_width=self.resource.sky.width(),
    )
    |> @ui.StaticUI::new(pos=@struct.Point::new(0, -100)),
  )
  let choices = if self.settings.female {
    self.resource.female_choices
  } else {
    self.resource.male_choices
  }

  // Draw clouds
  render_units.push(self.cloud_ui)
  if not(self.gender_selected) {
    // Draw gender selection board
    render_units.push(
      @graphics.Sprite::new(
        self.resource.board_gender_top,
        @graphics.DrawArgument::new(pos=@struct.Point::new(486, 95)),
      )
      |> @ui.SpriteUI,
    )
    render_units.push(
      @graphics.Sprite::new(
        self.resource.board_gender_mid,
        @graphics.DrawArgument::new(pos=@struct.Point::new(486, 209)),
      )
      |> @ui.SpriteUI,
    )
    render_units.push(
      @graphics.Sprite::new(
        self.resource.board_gender_bottom,
        @graphics.DrawArgument::new(pos=@struct.Point::new(486, 329)),
      )
      |> @ui.SpriteUI,
    )

    // Add gender selection buttons
    render_units.push(
      @ui.MapleButton::new(
        self.resource.bt_gender_male,
        pos=@struct.Point::new(487, 109),
      )
      |> @ui.Button::new(on_click=fn() {
        self.settings.female = false
        self.gender_selected = true
        (self.hooks.on_state_changed)()
        None
      }),
    )
    render_units.push(
      @ui.MapleButton::new(
        self.resource.bt_gender_female,
        pos=@struct.Point::new(485, 109),
      )
      |> @ui.Button::new(on_click=fn() {
        self.settings.female = true
        self.gender_selected = true
        (self.hooks.on_state_changed)()
        None
      }),
    )

    // Draw character preview
    match self.char_look_hook {
      Some((_, char_look)) => {
        let char_look_ui : CharLookUI = {
          char_look,
          pos: @struct.Point::new(394, 339),
        }
        render_units.push(char_look_ui)
      }
      None => ()
    }
  } else if not(self.charset_selected) {
    // Draw character customization board
    render_units.push(
      @graphics.Sprite::new(
        self.resource.board_char_set,
        @graphics.DrawArgument::new(pos=@struct.Point::new(486, 95)),
      )
      |> @ui.SpriteUI,
    )

    // Draw avatar selection sprites
    for i, _ in self.resource.avatar_sel {
      let f = if i >= 2 { i + 1 } else { i }
      render_units.push(
        @graphics.Sprite::new(
          self.resource.avatar_sel[i],
          @graphics.DrawArgument::new(pos=@struct.Point::new(497, 197 + f * 18)),
        )
        |> @ui.SpriteUI,
      )
    }

    // Add character customization buttons
    render_units.push_iter(
      [
        {
          compute: fn(f) { self.settings.face_idx = f(self.settings.face_idx) },
          part_choices: choices.faces,
        },
        {
          compute: fn(f) { self.settings.hair_idx = f(self.settings.hair_idx) },
          part_choices: choices.hairs,
        },
        {
          compute: fn(f) {
            self.settings.hair_color_idx = f(self.settings.hair_color_idx)
          },
          part_choices: choices.haircolors,
        },
        {
          compute: fn(f) { self.settings.skin_idx = f(self.settings.skin_idx) },
          part_choices: choices.skins,
        },
        {
          compute: fn(f) { self.settings.top_idx = f(self.settings.top_idx) },
          part_choices: choices.tops,
        },
        {
          compute: fn(f) { self.settings.bot_idx = f(self.settings.bot_idx) },
          part_choices: choices.bots,
        },
        {
          compute: fn(f) { self.settings.shoe_idx = f(self.settings.shoe_idx) },
          part_choices: choices.shoes,
        },
        {
          compute: fn(f) {
            self.settings.weapon_idx = f(self.settings.weapon_idx)
          },
          part_choices: choices.weapons,
        },
      ]
      .mapi(fn(i, it) {
        (
          @ui.MapleButton::new(
            self.resource.bt_left,
            pos=@struct.Point::new(552, 198 + i * 18),
          )
          |> @ui.Button::new(on_click=fn() {
            let count = it.part_choices.length()
            (it.compute)(fn(i) { (i - 1 + count) % count })
            (self.hooks.on_state_changed)()
            None
          }),
          @ui.MapleButton::new(
            self.resource.bt_right,
            pos=@struct.Point::new(684, 198 + i * 18),
          )
          |> @ui.Button::new(on_click=fn() {
            let count = it.part_choices.length()
            (it.compute)(fn(i) { (i + 1) % count })
            (self.hooks.on_state_changed)()
            None
          }),
        )
      })
      .iter()
      .flat_map(fn(it) {
        [it.0 as &@ui.RenderUnit, it.1 as &@ui.RenderUnit].iter()
      }),
    )
    match self.char_look_hook {
      Some((_, char_look)) => {
        // Draw equipment names
        render_units.push_iter(
          [
            (
              char_look.get_face().get_name(),
              @struct.Point::new(625, 193 + 0 * 18),
            ),
            (
              char_look.get_hair().get_name(),
              @struct.Point::new(625, 193 + 1 * 18),
            ),
            (
              char_look.get_body().get_name(),
              @struct.Point::new(625, 193 + 3 * 18),
            ),
            // TODO: show equips name
            // (
            //   char_look.get_equips()
            //   @struct.Point::new(625, 193 + 4 * 18),
            // ),
            // (
            //   char_look.get_shoe().get_name(),
            //   @struct.Point::new(625, 193 + 5 * 18),
            // ),
            // (
            //   char_look.get_wep().get_name(),
            //   @struct.Point::new(625, 193 + 6 * 18),
            // ),
          ]
          .iter()
          .map(fn(it) {
            let (text, pos) = it
            @graphics.Text::new(
              @graphics.A11M,
              @graphics.TextAlignment::CENTER,
              @struct.ColorName::BLACK,
              text~,
            )
            |> @ui.TextUI
            |> @ui.StaticUI::new(pos~)
          }),
        )

        // Draw character preview
        let char_look_ui : CharLookUI = {
          char_look,
          pos: @struct.Point::new(394, 339),
        }
        render_units.push(char_look_ui)
      }
      None => ()
    }
    render_units.push(
      @ui.MapleButton::new(
        self.resource.bt_yes,
        pos=@struct.Point::new(514, 394),
      )
      |> @ui.Button::new(on_click=fn() {
        self.charset_selected = true
        (self.hooks.on_state_changed)()
        None
      }),
    )
  } else {
    render_units.push(
      @ui.StaticUI::new(
        @ui.TextureUI(self.resource.nameboard),
        pos=@struct.Point::new(486, 95),
      ),
    )
    render_units.push(
      @ui.MapleButton::new(
        self.resource.bt_yes,
        pos=@struct.Point::new(514, 394),
      )
      |> @ui.Button::new(on_click=fn() {
        (self.on_create_char)({
          name: "kkkiio" + self.randomizer.next_int(1000, from=2).to_string(),
          job: JOB_ID_EXPLORER,
          female: self.settings.female,
          skin_id: choices.skins[self.settings.skin_idx],
          hair_id: choices.hairs[self.settings.hair_idx],
          hair_color_id: choices.haircolors[self.settings.hair_color_idx],
          face_id: choices.faces[self.settings.face_idx],
          top_id: choices.tops[self.settings.top_idx],
          bot_id: choices.bots[self.settings.bot_idx],
          shoe_id: choices.shoes[self.settings.shoe_idx],
          weapon_id: choices.weapons[self.settings.weapon_idx],
        })
        None
      }),
    )
  }
  { render_units, }
}

///|
pub fn remove_cursor(self : ExplorerCreatorUI) -> Unit {
  // TODO: remove
}

///|
pub fn send_key(
  self : ExplorerCreatorUI,
  keycode : Int,
  pressed : Bool,
  escape : Bool
) -> Unit {
  // TODO: remove
}

///|
pub fn get_ui_model(self : ExplorerCreatorUI) -> @ui.UIModel {
  self.model
}

///|
const JOB_ID_EXPLORER = 1

///| Reserve a name for the character to be created.
fn new_name_char_packet(name : String) -> @net.OutPacket {
  @net.OutPacket::new(@net.OutPacketOpcode::NAME_CHAR)..write_string(name)
}

///| Requests creation of a character with the specified stats.
fn new_create_char_packet(
  name : String,
  job : Int,
  face : Int,
  hair : Int,
  hairc : Int,
  skin : Int,
  top : Int,
  bot : Int,
  shoes : Int,
  weapon : Int,
  female : Bool
) -> @net.OutPacket {
  @net.OutPacket::new(@net.OutPacketOpcode::CREATE_CHAR)
  ..write_string(name)
  ..write_int(job)
  ..write_int(face)
  ..write_int(hair)
  ..write_int(hairc)
  ..write_int(skin)
  ..write_int(top)
  ..write_int(bot)
  ..write_int(shoes)
  ..write_int(weapon)
  ..write_byte(female.to_int().to_byte())
}

///|
pub fn get_map_latest_loader() -> @resource.AsyncLoader {
  @resource.AsyncLoader::new("MapLatest")
}

///|
fn load_char_look(self : ExplorerCreatorUI) -> Unit {
  match self.char_look_hook {
    Some((actual, _)) => if self.settings == actual { return }
    None => ()
  }
  let expect = { ..self.settings }
  (self.load_char_look_async)(expect.to_look_entry(self.resource), fn(look) {
    look.set_stance(@types.StanceId::STAND1)
    look.set_direction(true)
    self.char_look_hook = Some((expect, look))
    (self.hooks.on_state_changed)()
  })
}

///|
fn rand_char_look(
  female : Bool,
  randomizer : @utils.Randomizer,
  resource : ExplorerCreatorUIResource
) -> LookSettingState {
  let choices = if female {
    resource.female_choices
  } else {
    resource.male_choices
  }
  let hair_idx = randomizer.next_int(choices.hairs.length())
  let face_idx = randomizer.next_int(choices.faces.length())
  let skin_idx = randomizer.next_int(choices.skins.length())
  let hair_color_idx = randomizer.next_int(choices.haircolors.length())
  let top_idx = randomizer.next_int(choices.tops.length())
  let bot_idx = 0
  let shoe_idx = randomizer.next_int(choices.shoes.length())
  let weapon_idx = randomizer.next_int(choices.weapons.length())
  {
    female,
    skin_idx,
    hair_color_idx,
    face_idx,
    hair_idx,
    top_idx,
    bot_idx,
    shoe_idx,
    weapon_idx,
  }
}

///|
fn to_look_entry(
  self : LookSettingState,
  resource : ExplorerCreatorUIResource
) -> @char_look.LookEntry {
  let female = self.female
  let choices = if female {
    resource.female_choices
  } else {
    resource.male_choices
  }
  {
    female,
    skin: choices.skins[self.skin_idx],
    faceid: choices.faces[self.face_idx],
    hairid: choices.hairs[self.hair_idx] +
    choices.haircolors[self.hair_color_idx],
    equips: [
      (@slot.Id::TOP.int_value(), choices.tops[self.top_idx]),
      (@slot.Id::BOTTOM.int_value(), choices.bots[self.bot_idx]),
      (@slot.Id::SHOES.int_value(), choices.shoes[self.shoe_idx]),
      (@slot.Id::WEAPON.int_value(), choices.weapons[self.weapon_idx]),
    ]
    |> Map::from_array,
    maskedequips: {},
    petids: [],
  }
}

///|
struct CloudUI {
  texture : @graphics.Texture
  mut x : Float
} derive(ToJson)

///|
pub impl @graphics.Drawable for CloudUI with draw(self, _) -> Unit {
  let cloudx = self.x.to_int() % 800
  self.texture.draw(
    @graphics.DrawArgument::new(
      pos=@struct.Point::new(cloudx - self.texture.width(), 310),
    ),
  )
  self.texture.draw(
    @graphics.DrawArgument::new(pos=@struct.Point::new(cloudx, 310)),
  )
  self.texture.draw(
    @graphics.DrawArgument::new(
      pos=@struct.Point::new(cloudx + self.texture.width(), 310),
    ),
  )
}

///|
pub impl @ui.RenderUnit for CloudUI with update(self) -> Unit { self.x += 0.5 }

///|
pub impl @ui.RenderUnit for CloudUI with get_interactive_area(self) {
  ignore(self)
  None
}

///|
struct IndexSelector {
  compute : ((Int) -> Int) -> Unit
  part_choices : Array[Int]
}
