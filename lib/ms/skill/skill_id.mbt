///|
pub(all) enum SkillId {
  // Beginner
  FOLLOW_THE_LEAD
  ANGEL_BLESSING
  THREE_SNAILS
  HEAL
  FEATHER
  LEGENDARY_SPIRIT
  MONSTER_RIDER
  ECHO_OF_THE_HERO

  // Swordman
  IMPROVED_HP_RECOVERY
  IMPROVED_MAX_HP
  IMPROVED_LADDER_RECOVERY
  IRON_BODY
  POWER_STRIKE
  SLASH_BLAST

  // Fighter
  SWORD_MASTERY_FIGHTER
  AXE_MASTERY
  SWORD_FA_FIGHTER
  AXE_FA
  SWORD_BOOSTER_FIGHTER
  AXE_BOOSTER
  RAGE
  POWER_GUARD_FIGHTER

  // Crusader
  IMPROVED_MP_RECOVERY_CRUSADER
  SHIELD_MASTERY
  SWORD_PANIC
  AXE_PANIC
  SWORD_COMA
  AXE_COMA
  SHOUT

  // Hero
  ADVANCED_COMBO_ATTACK
  ACHILLES_HERO
  GUARDIAN_HERO
  RUSH_HERO
  BRANDISH

  // Page
  SWORD_MASTERY_PAGE
  BW_MASTERY
  SWORD_FA_PAGE
  BW_FA
  SWORD_BOOSTER_PAGE
  BW_BOOSTER
  THREATEN
  POWER_GUARD_PAGE

  // White Knight
  CHARGE

  // Paladin
  ACHILLES_PALADIN
  GUARDIAN_PALADIN
  ADVANCED_CHARGE
  RUSH_PALADIN
  BLAST
  HEAVENS_HAMMER

  // Spearman
  SPEAR_MASTERY
  PA_MASTERY
  SPEAR_FA
  PA_FA
  SPEAR_BOOSTER
  PA_BOOSTER
  IRON_WILL
  HYPER_BODY

  // Dragon Knight
  DRAGON_BUSTER
  DRAGON_FURY
  PA_BUSTER
  PA_FURY
  SACRIFICE
  DRAGONS_ROAR

  // Dark Knight
  ACHILLES_DK
  BERSERK
  BEHOLDER_HEAL
  BEHOLDER_BUFF
  RUSH_DK
  BEHOLDER

  // Magician
  IMPROVE_MP_RECOVERY
  IMPROVE_MAX_MP
  MAGIC_GUARD
  MAGIC_ARMOR
  ENERGY_BOLT
  MAGIC_CLAW

  // F/P Mage
  MP_EATER_FP
  MEDITATION_FP
  TELEPORT_FP
  SLOW_FP
  FIRE_ARROW
  POISON_BREATH

  // F/P Archmage
  PARTIAL_RESISTANCE_FP
  ELEMENT_AMPLIFICATION_FP
  EXPLOSION
  POISON_MIST
  SEAL_FP
  SPELL_BOOSTER_FP
  ELEMENT_COMPOSITION_FP

  // TODO: ?
  FIRE_DEMON
  ELQUINES
  PARALYZE
  METEOR_SHOWER

  // I/L Mage
  IL_TELEPORT

  // Priest
  PRIEST_TELEPORT

  // Hermit
  AVENGER
  FLASH_JUMP

  // Night Lord
  TRIPLE_THROW

  // Bandit
  MESO_EXPLOSION
} derive(Eq)

///|
pub fn int_value(self : SkillId) -> Int {
  match self {
    // Beginner
    SkillId::FOLLOW_THE_LEAD => 8
    SkillId::ANGEL_BLESSING => 12
    SkillId::THREE_SNAILS => 1000
    SkillId::HEAL => 1001
    SkillId::FEATHER => 1002
    SkillId::LEGENDARY_SPIRIT => 1003
    SkillId::MONSTER_RIDER => 1004
    SkillId::ECHO_OF_THE_HERO => 1005

    // Swordman
    SkillId::IMPROVED_HP_RECOVERY => 1000000
    SkillId::IMPROVED_MAX_HP => 1000001
    SkillId::IMPROVED_LADDER_RECOVERY => 1000002
    SkillId::IRON_BODY => 1001003
    SkillId::POWER_STRIKE => 1001004
    SkillId::SLASH_BLAST => 1001005

    // Fighter
    SkillId::SWORD_MASTERY_FIGHTER => 1100000
    SkillId::AXE_MASTERY => 1100001
    SkillId::SWORD_FA_FIGHTER => 1100002
    SkillId::AXE_FA => 1100003
    SkillId::SWORD_BOOSTER_FIGHTER => 1101004
    SkillId::AXE_BOOSTER => 1101005
    SkillId::RAGE => 1101006
    SkillId::POWER_GUARD_FIGHTER => 1101007

    // Crusader
    SkillId::IMPROVED_MP_RECOVERY_CRUSADER => 1110000
    SkillId::SHIELD_MASTERY => 1110001
    SkillId::SWORD_PANIC => 1111003
    SkillId::AXE_PANIC => 1111004
    SkillId::SWORD_COMA => 1111005
    SkillId::AXE_COMA => 1111005
    SkillId::SHOUT => 1111008

    // Hero
    SkillId::ADVANCED_COMBO_ATTACK => 1120003
    SkillId::ACHILLES_HERO => 1120004
    SkillId::GUARDIAN_HERO => 1120005
    SkillId::RUSH_HERO => 1121006
    SkillId::BRANDISH => 1121008

    // Page
    SkillId::SWORD_MASTERY_PAGE => 1200000
    SkillId::BW_MASTERY => 1200001
    SkillId::SWORD_FA_PAGE => 1200002
    SkillId::BW_FA => 1200003
    SkillId::SWORD_BOOSTER_PAGE => 1201004
    SkillId::BW_BOOSTER => 1201005
    SkillId::THREATEN => 1201006
    SkillId::POWER_GUARD_PAGE => 1201007

    // White Knight
    SkillId::CHARGE => 1211002

    // Paladin
    SkillId::ACHILLES_PALADIN => 1220005
    SkillId::GUARDIAN_PALADIN => 1220006
    SkillId::ADVANCED_CHARGE => 1220010
    SkillId::RUSH_PALADIN => 1221007
    SkillId::BLAST => 1221009
    SkillId::HEAVENS_HAMMER => 1221011

    // Spearman
    SkillId::SPEAR_MASTERY => 1300000
    SkillId::PA_MASTERY => 1300001
    SkillId::SPEAR_FA => 1300002
    SkillId::PA_FA => 1300003
    SkillId::SPEAR_BOOSTER => 1301004
    SkillId::PA_BOOSTER => 1301005
    SkillId::IRON_WILL => 1301006
    SkillId::HYPER_BODY => 1301007

    // Dragon Knight
    SkillId::DRAGON_BUSTER => 1311001
    SkillId::DRAGON_FURY => 1311002
    SkillId::PA_BUSTER => 1311003
    SkillId::PA_FURY => 1311004
    SkillId::SACRIFICE => 1311005
    SkillId::DRAGONS_ROAR => 1311006

    // Dark Knight
    SkillId::ACHILLES_DK => 1320005
    SkillId::BERSERK => 1320006
    SkillId::BEHOLDER_HEAL => 1320008
    SkillId::BEHOLDER_BUFF => 1320009
    SkillId::RUSH_DK => 1321003
    SkillId::BEHOLDER => 1321007

    // Magician
    SkillId::IMPROVE_MP_RECOVERY => 2000000
    SkillId::IMPROVE_MAX_MP => 2000001
    SkillId::MAGIC_GUARD => 2001002
    SkillId::MAGIC_ARMOR => 2001003
    SkillId::ENERGY_BOLT => 2001004
    SkillId::MAGIC_CLAW => 2001005

    // F/P Mage
    SkillId::MP_EATER_FP => 2100000
    SkillId::MEDITATION_FP => 2101001
    SkillId::TELEPORT_FP => 2101002
    SkillId::SLOW_FP => 2101003
    SkillId::FIRE_ARROW => 2101004
    SkillId::POISON_BREATH => 2101005

    // F/P Archmage
    SkillId::PARTIAL_RESISTANCE_FP => 2110000
    SkillId::ELEMENT_AMPLIFICATION_FP => 2110001
    SkillId::EXPLOSION => 2111002
    SkillId::POISON_MIST => 2111003
    SkillId::SEAL_FP => 2111004
    SkillId::SPELL_BOOSTER_FP => 2111005
    SkillId::ELEMENT_COMPOSITION_FP => 2111006

    // TODO: ?
    SkillId::FIRE_DEMON => 2121003
    SkillId::ELQUINES => 2121005
    SkillId::PARALYZE => 2121006
    SkillId::METEOR_SHOWER => 2121007

    // I/L Mage
    SkillId::IL_TELEPORT => 2201002

    // Priest
    SkillId::PRIEST_TELEPORT => 2301001

    // Hermit
    SkillId::AVENGER => 4111005
    SkillId::FLASH_JUMP => 4111006

    // Night Lord
    SkillId::TRIPLE_THROW => 4121007

    // Bandit
    SkillId::MESO_EXPLOSION => 4211006
  }
}

///|
pub(all) type! UnknownSkillId Int derive(Show)

///|
pub fn SkillId::from_int(value : Int) -> SkillId!UnknownSkillId {
  match value {
    // Beginner
    8 => SkillId::FOLLOW_THE_LEAD
    12 => SkillId::ANGEL_BLESSING
    1000 => SkillId::THREE_SNAILS
    1001 => SkillId::HEAL
    1002 => SkillId::FEATHER
    1003 => SkillId::LEGENDARY_SPIRIT
    1004 => SkillId::MONSTER_RIDER
    1005 => SkillId::ECHO_OF_THE_HERO

    // Swordman
    1000000 => SkillId::IMPROVED_HP_RECOVERY
    1000001 => SkillId::IMPROVED_MAX_HP
    1000002 => SkillId::IMPROVED_LADDER_RECOVERY
    1001003 => SkillId::IRON_BODY
    1001004 => SkillId::POWER_STRIKE
    1001005 => SkillId::SLASH_BLAST

    // Fighter
    1100000 => SkillId::SWORD_MASTERY_FIGHTER
    1100001 => SkillId::AXE_MASTERY
    1100002 => SkillId::SWORD_FA_FIGHTER
    1100003 => SkillId::AXE_FA
    1101004 => SkillId::SWORD_BOOSTER_FIGHTER
    1101005 => SkillId::AXE_BOOSTER
    1101006 => SkillId::RAGE
    1101007 => SkillId::POWER_GUARD_FIGHTER

    // Crusader
    1110000 => SkillId::IMPROVED_MP_RECOVERY_CRUSADER
    1110001 => SkillId::SHIELD_MASTERY
    1111003 => SkillId::SWORD_PANIC
    1111004 => SkillId::AXE_PANIC
    1111005 => SkillId::SWORD_COMA
    // 1111005 => SkillId::AXE_COMA // ???
    1111008 => SkillId::SHOUT

    // Hero
    1120003 => SkillId::ADVANCED_COMBO_ATTACK
    1120004 => SkillId::ACHILLES_HERO
    1120005 => SkillId::GUARDIAN_HERO
    1121006 => SkillId::RUSH_HERO
    1121008 => SkillId::BRANDISH

    // Page
    1200000 => SkillId::SWORD_MASTERY_PAGE
    1200001 => SkillId::BW_MASTERY
    1200002 => SkillId::SWORD_FA_PAGE
    1200003 => SkillId::BW_FA
    1201004 => SkillId::SWORD_BOOSTER_PAGE
    1201005 => SkillId::BW_BOOSTER
    1201006 => SkillId::THREATEN
    1201007 => SkillId::POWER_GUARD_PAGE

    // White Knight
    1211002 => SkillId::CHARGE

    // Paladin
    1220005 => SkillId::ACHILLES_PALADIN
    1220006 => SkillId::GUARDIAN_PALADIN
    1220010 => SkillId::ADVANCED_CHARGE
    1221007 => SkillId::RUSH_PALADIN
    1221009 => SkillId::BLAST
    1221011 => SkillId::HEAVENS_HAMMER

    // Spearman
    1300000 => SkillId::SPEAR_MASTERY
    1300001 => SkillId::PA_MASTERY
    1300002 => SkillId::SPEAR_FA
    1300003 => SkillId::PA_FA
    1301004 => SkillId::SPEAR_BOOSTER
    1301005 => SkillId::PA_BOOSTER
    1301006 => SkillId::IRON_WILL
    1301007 => SkillId::HYPER_BODY

    // Dragon Knight
    1311001 => SkillId::DRAGON_BUSTER
    1311002 => SkillId::DRAGON_FURY
    1311003 => SkillId::PA_BUSTER
    1311004 => SkillId::PA_FURY
    1311005 => SkillId::SACRIFICE
    1311006 => SkillId::DRAGONS_ROAR

    // Dark Knight
    1320005 => SkillId::ACHILLES_DK
    1320006 => SkillId::BERSERK
    1320008 => SkillId::BEHOLDER_HEAL
    1320009 => SkillId::BEHOLDER_BUFF
    1321003 => SkillId::RUSH_DK
    1321007 => SkillId::BEHOLDER

    // Magician
    2000000 => SkillId::IMPROVE_MP_RECOVERY
    2000001 => SkillId::IMPROVE_MAX_MP
    2001002 => SkillId::MAGIC_GUARD
    2001003 => SkillId::MAGIC_ARMOR
    2001004 => SkillId::ENERGY_BOLT
    2001005 => SkillId::MAGIC_CLAW

    // F/P Mage
    2100000 => SkillId::MP_EATER_FP
    2101001 => SkillId::MEDITATION_FP
    2101002 => SkillId::TELEPORT_FP
    2101003 => SkillId::SLOW_FP
    2101004 => SkillId::FIRE_ARROW
    2101005 => SkillId::POISON_BREATH

    // F/P Archmage
    2110000 => SkillId::PARTIAL_RESISTANCE_FP
    2110001 => SkillId::ELEMENT_AMPLIFICATION_FP
    2111002 => SkillId::EXPLOSION
    2111003 => SkillId::POISON_MIST
    2111004 => SkillId::SEAL_FP
    2111005 => SkillId::SPELL_BOOSTER_FP
    2111006 => SkillId::ELEMENT_COMPOSITION_FP

    // TODO: ?
    2121003 => SkillId::FIRE_DEMON
    2121005 => SkillId::ELQUINES
    2121006 => SkillId::PARALYZE
    2121007 => SkillId::METEOR_SHOWER

    // I/L Mage
    2201002 => SkillId::IL_TELEPORT

    // Priest
    2301001 => SkillId::PRIEST_TELEPORT

    // Hermit
    4111005 => SkillId::AVENGER
    4111006 => SkillId::FLASH_JUMP

    // Night Lord
    4121007 => SkillId::TRIPLE_THROW

    // Bandit
    4211006 => SkillId::MESO_EXPLOSION
    _ => raise UnknownSkillId(value)
  }
}

///|
pub fn hash(self : SkillId) -> Int {
  self.int_value()
}

///|
pub fn hash_combine(self : SkillId, hasher : Hasher) -> Unit {
  hasher.combine(self.int_value())
}
