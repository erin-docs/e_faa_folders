#aggregate_awareness: yes


explore: faa_flights {

  join: faa_carriers {foreign_key: carrier}
  join: faa_origin {from:faa_airports  foreign_key:origin fields:[full_name,state,code,location]}
  join: faa_destination {from:faa_airports  foreign_key:destination fields:[full_name,state,code,location]}
  join: faa_aircraft {foreign_key: tail_num fields:[tail_num,year_built,count]}
  join: faa_aircraft_models {foreign_key:faa_aircraft.aircraft_model_code }

  query: _preview {
    dimensions: [dep_time,flight_num,carrier,origin,destination,faa_aircraft_models.manufacturer,dep_delay,arr_delay]
  }

  query: carrier_by_flights_count {
    dimensions: [faa_carriers.nickname]
    measures: [count]
    sort: {field:count  desc:yes}
  }
  query: destinations_by_filghts_count_top_5 {
    dimensions: [destination]
    measures: [count]
    sort: {field:count  desc:yes}
    limit: 5
  }
  query: destinations_by_total_seats_top_5 {
    dimensions: [destination]
    measures: [total_seats]
    sort: {field:total_seats  desc:yes}
    limit: 5
  }
  query: aircraft_manufacturer_by_flights_count_top_5 {
    dimensions: [faa_aircraft_models.manufacturer]
    measures: [count]
    sort: {field:count  desc:yes}
    limit: 5
  }
  query: aircraft_manufacturer_by_aircraft_count_top_5 {
    dimensions: [faa_aircraft_models.manufacturer]
    measures: [faa_aircraft.count]
    sort: {field:faa_aircraft.count  desc:yes}
    limit: 5
  }
  query: number_of_seats_on_plane_by_flights_count {
    dimensions: [faa_aircraft_models.seats]
    measures: [faa_aircraft.count]
    sort: {field:faa_aircraft_models.seats  desc:no}
    filters: {field:faa_aircraft_models.seats value:">0"}
  }
  query: timeliness_by_flights_count {
    dimensions: [timeliness]
    measures: [count]
    sort: {field:timeliness  desc:no}
  }
  query: distance_by_flights_count {
    dimensions: [distance_tiered]
    measures: [count]
    sort: {field:distance_tiered  desc:no}
  }
  query: flight_month_by_flights_count {
    dimensions: [dep_month]
    measures: [count]
    sort: {field:dep_month  desc:no}
  }
  query: aircraft_age_by_flights_count {
    dimensions: [aircraft_age_tiered]
    measures: [count]
    filters: {field:aircraft_age_tiered value:"-TXX%"}
    sort: {field:aircraft_age_tiered  desc:no}
    limit: 5
  }
}

view: faa_flights {

  measure: count {
    type: count
  }

  measure: total_seats {
    type: sum
    sql: ${faa_aircraft_models.seats} ;;
  }

  measure: total_distance {
    type: sum
    sql: ${distance} ;;
  }

  dimension: carrier {}
  dimension: origin {}
  dimension: destination {}
  dimension: flight_num {}
  dimension: flight_time {type: number}
  dimension: tail_num {}
  dimension_group: dep {type: time  sql: ${TABLE}.dep_time;; }
  dimension_group: arr {type: time}
  dimension: dep_delay {type: number}
  dimension: arr_delay {type: number}
  dimension: distance {type: number}
  dimension: cancelled {}
  dimension: diverted {}

  dimension: aircraft_age {type:number  sql:${dep_year}-${faa_aircraft.year_built};;}
  dimension: aircraft_age_tiered {
    type:tier
    sql: ${aircraft_age} ;;
    tiers: [5, 12]
  }

  dimension: id2 {type: number hidden:yes}

  dimension: timeliness {
    case: {
      when: { label: "Very Late" sql: ${arr_delay} > 60 ;;}
      when: { label: "Late" sql: ${arr_delay} > 20 ;;}
      when: { label: "Ontime" sql: ${arr_delay} <= 20 ;;}
    }
  }

  dimension: leg {
    sql: CONCAT(${origin},'-',${destination}) ;;
  }

#   dimension: distance_tiered {
#     type: tier
#     sql: ${distance} ;;
#     tiers: [500,1300]
#   }

  dimension: distance_tiered {
    case: {
      when: { label: "short" sql: ${distance} < 500 ;;}
      when: { label: "medium" sql: ${distance} < 1300 ;;}
      when: { label: "long" sql: ${distance} >= 1300 ;;}
    }
  }

  parameter: explore_by {
    type: unquoted
    allowed_value: { label: "Carrier" value: "carrier" }
    allowed_value: { label: "Origin Airport" value: "airport" }
    allowed_value: { label: "Aircraft Manufacturer" value: "aircraft_maker" }
    allowed_value: { label: "Aircraft Model" value: "aircraft_model" }
  }

  dimension: explore_by_field {
    sql: CONCAT(
          {% if explore_by._parameter_value == 'carrier' %}
            ${faa_carriers.nickname}
          {% elsif explore_by._parameter_value == 'airport' %}
            ${faa_origin.full_name}
          {% elsif explore_by._parameter_value == 'aircraft_maker' %}
            ${faa_aircraft_models.manufacturer}
          {% elsif explore_by._parameter_value == 'aircraft_model' %}
            CONCAT( ${faa_aircraft_models.manufacturer}, ' ', ${faa_aircraft_models.model})
          {% else %}
            ''
          {% endif %},' ');;
  }

}



view: faa_carriers {

  measure: count {
    type: count
    drill_fields: [code, name]
  }

  dimension: code {primary_key: yes}
  dimension: name {}
  dimension: nickname {}
}

explore: airports_base {
  extension: required
  query: _view_data {
    dimensions: [code,full_name,facility_type,elevation,city,state,location,has_control_tower]
  }
  query: airports_by_control_towers {
    dimensions: [has_control_tower]
    measures: [count]
  }
  query: airports_by_state {
    dimensions: [state]
    measures: [count]
    sort: {field:count desc:yes}
  }
  query: airports_by_facility_type {
    dimensions: [facility_type]
    measures: [count]
    sort: {field:facility_type desc:no}
  }

  query: airports_by_city_top_10 {
    dimensions: [city]
    measures: [count]
    sort: {field:count desc:yes}
    limit: 10
  }
  query: heliports_by_state {
    dimensions: [state]
    measures: [count]
    sort: {field:count desc:yes}
    filters: {field:facility_type value:"HELIPORT"}
  }
  query: heliports_by_city_top_10 {
    dimensions: [city]
    measures: [count]
    sort: {field:count desc:yes}
    filters: {field:facility_type value:"HELIPORT"}
    limit: 10
  }
  query: airport_name_by_max_elevation_top_10 {
    dimensions: [full_name]
    measures: [max_elevation]
    sort: {field:max_elevation desc:yes}
    limit: 10
  }

}

view: faa_airports {

  measure: count {
    type: count
  }

  drill_fields: [code,full_name,facility_type,elevation,city,state,location,has_control_tower]
  dimension: code {primary_key: yes}

  dimension: city {}
  dimension: county {}
  dimension: state {}
  dimension: full_name {}
  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }
  dimension: has_control_tower {
    type: yesno
    sql: ${TABLE}.cntl_twr ='Y';;
  }
  dimension: facility_type {
    sql: ${TABLE}.fac_type ;;
  }
  dimension: elevation {type:number}
  measure: max_elevation {type:max sql: ${elevation} ;;}
}


view: faa_aircraft {

  drill_fields: [tail_num,aircraft_model_code,aircraft_models.manufacturer]

  measure: count {type: count}

  dimension: tail_num {primary_key:yes}
  dimension: aircraft_serial {}
  dimension: aircraft_model_code {}
  dimension: aircraft_engine_code {}
  dimension: year_built {type: number hidden:yes}
  dimension: aircraft_type_id {}
}

view: faa_aircraft_models {

  measure: count {
    type: count
  }
  drill_fields: [aircraft_model_code, manufacturer, model, engines, seats]

  dimension: aircraft_model_code {primary_key:yes}
  dimension: manufacturer {}
  dimension: model {}
  dimension: engines {type:number}
  dimension: seats {type:number}
  dimension: weight {}
  dimension: speed {}
}
