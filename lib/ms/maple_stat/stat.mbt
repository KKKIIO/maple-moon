///|
pub(all) enum Id {
  SKIN
  FACE
  HAIR
  LEVEL
  JOB
  STR
  DEX
  INT
  LUK
  HP
  MAXHP
  MP
  MAXMP
  AP
  SP
  EXP
  FAME
  MESO
  PET
  GACHAEXP
} derive(Eq, Hash, Show)

///|
pub fn int_value(self : Id) -> Int {
  match self {
    Id::SKIN => 0x1
    Id::FACE => 0x2
    Id::HAIR => 0x4
    Id::LEVEL => 0x10
    Id::JOB => 0x20
    Id::STR => 0x40
    Id::DEX => 0x80
    Id::INT => 0x100
    Id::LUK => 0x200
    Id::HP => 0x400
    Id::MAXHP => 0x800
    Id::MP => 0x1000
    Id::MAXMP => 0x2000
    Id::AP => 0x4000
    Id::SP => 0x8000
    Id::EXP => 0x10000
    Id::FAME => 0x20000
    Id::MESO => 0x40000
    Id::PET => 0x180008
    Id::GACHAEXP => 0x200000
  }
}

///|
pub impl Compare for Id with compare(self, other) -> Int {
  self.int_value().compare(other.int_value())
}

///|
pub let all_stats : Array[Id] = [
  SKIN,
  FACE,
  HAIR,
  LEVEL,
  JOB,
  STR,
  DEX,
  INT,
  LUK,
  HP,
  MAXHP,
  MP,
  MAXMP,
  AP,
  SP,
  EXP,
  FAME,
  MESO,
  PET,
  GACHAEXP,
]
