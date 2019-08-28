connection: "faa"

include: "/Views/accidents.view"
include: "/Views/aircraft/*.view"

map_layer: world {
  file: "/Data/world.topo.json"
}

explore: accidents {}

explore: aircraft_engine_types {}

explore: aircraft {
  join: aircraft_types {
    type: left_outer
    sql_on: ${aircraft.aircraft_type_id} = ${aircraft_types.aircraft_type_id} ;;
    relationship: many_to_one
  }

  join: aircraft_engine_types {
    type: left_outer
    sql_on: ${aircraft.aircraft_engine_type_id} = ${aircraft_engine_types.aircraft_engine_type_id} ;;
    relationship: many_to_one
  }
}
