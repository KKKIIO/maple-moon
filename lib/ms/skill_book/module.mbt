///|
struct Module {
  player_getter : () -> @player.Player?
  skill : @resource.NxNode
}

///|
pub fn Module::load(
  player_getter : () -> @player.Player?
) -> @utils.Future[Module] {
  @ui.ui_window_2_loader().load_res(["Skill"])
  |> @utils.map(fn(skill) { Module::new(player_getter, skill) })
}

///|
fn Module::new(
  player_getter : () -> @player.Player?,
  skill : @resource.NxNode
) -> Module {
  { player_getter, skill }
}

///|
pub fn make_handlers(
  self : Module
) -> Map[@net.Opcode, (@net.InPacket) -> Unit] {
  [
    @net.make_handler(
      @net.UPDATE_SKILL,
      parse_skill_update,
      fn(update : SkillUpdate) { handle_skill_update(self.player_getter, update) }
    ),
  ]
  |> Map::from_array
}

///|
pub fn make_actions(
  self : Module
) -> Map[@keyboard.ActionId, @action.Descriptor] {
  [
    (
      @keyboard.ActionId::SKILLS,
      @action.Descriptor::UI(key=@ui.UIElementType::SKILL_BOOK, focused=false, make_element=fn(

      ) {
        let player = (self.player_getter)().unwrap()
        let stats = player.get_stats()
        let skillbook = player.get_skills()
        @ui.Element::new(
          fn(hooks) {
            let ui = SkillBookUI::new(
              {
                skillbook,
                job: stats.get_job(),
                level: stats.get_stat(@maple_stat.Id::LEVEL),
                sp: stats.get_stat(@maple_stat.Id::SP),
              },
              self.skill,
              hooks,
            )
            stats.watch_stat_changes(@maple_stat.Id::SP, fn(_old, sp) {
              guard ui.get_ui_model().active else { return IterEnd }
              ui.set_attributes({
                skillbook: player.get_skills(),
                job: stats.get_job(),
                level: stats.get_stat(@maple_stat.Id::LEVEL),
                sp,
              })
              IterContinue
            })
            skillbook.listen_skill_level_changes(fn(_skill_id, _level) { // TODO: fine-granular update
              guard ui.get_ui_model().active else { return IterEnd }
              ui.set_attributes({
                skillbook,
                job: stats.get_job(),
                level: stats.get_stat(@maple_stat.Id::LEVEL),
                sp: stats.get_stat(@maple_stat.Id::SP),
              })
              IterContinue
            })
            ui
          },
          @ui.UIElementType::SKILL_BOOK,
        )
      }),
    ),
  ]
  |> Map::from_array
}
