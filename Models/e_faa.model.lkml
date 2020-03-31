connection: "faa"


include: "/Views/aircraft/*.view"
include: "/Views/*.view"
include: "/Explores/faa.explore.lkml"

map_layer: world {
  file: "/Data/world.topo.json"
}

datagroup: e_faa_datagroup {
  #label: "ETL ID added"
  #description: "Triggered when a new ETL ID is added"
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

explore: accidents {
  description: "Accidents"
}
