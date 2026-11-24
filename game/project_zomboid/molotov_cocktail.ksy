# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/31_molotov_cocktail.ksy
# Licence and copyright: see _community/README.md
meta:
  id: molotov_cocktail
  title: 'Project Zomboid save: Molotov cocktail object'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  # IsoMolotovCocktail inherits from MovingObject which overrides IsoObject.load
  # It likely doesn't serialize (no load method override found)
  # Keeping this as empty for completeness
  []
